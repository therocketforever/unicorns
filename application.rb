## Website ##
class Application < Sinatra::Base
  
  enable :logging, :inline_templates
  
	register Sinatra::MultiRoute

  configure :test do
    DataMapper.setup(:default, "sqlite://#{Dir.pwd}/features/support/test.db")
  end
 
  configure :development do
    Bundler.require(:development)
    DataMapper.setup(:default, "sqlite://#{Dir.pwd}/development.db")
  end

  configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL']) 
  end

  helpers do
    def evaluate_path
     @target = case request.path
        when '/red'
          :red
        when '/blue'
          :blue
        when '/gold'
          :gold
        else
          :red
      end
    end
    
    def paginate(query)
      @page     = (params[:page] || 1).to_i
      @per_page = (params[:per_page] || 10).to_i

      query[((@page - 1) * @per_page), @per_page]
    end
  end

  get "/style.css" do
    content_type 'text/css', :charset => 'utf-8'
    scss :style
  end
  
  get "/core.js" do
    coffee :core
  end
  
  get "/application.js" do
    coffee :application
  end

  get "/", "/red", "/blue", "/gold" do
    @title = "therocketforever"
    evaluate_path
		case @target
			when :red
        @articles = paginate(Article.all(:section => "red", :order => :created_at.asc))
      when :blue
        @articles = paginate(Article.all(:section => "blue", :order => :updated_at.asc))
      when :gold
        @articles = paginate(Article.all(:section => "gold", :order => :weight.asc))
			else
			  @articles = paginate(Article.all(:section => "red", :order => :created_at.asc))
		end
    slim :index
  end
end


## Opperational Objects ##

module Agency
end

module Operations
  # Process tags from markdown for insortion into DataBase. Tags should be assigned if they already exist & created if they do not. This should be done transactionaly as a redis worker task & return true or false on sucess/failure.  
  def tag(target = self)
    puts "Processing tags for #{target}"
    return true
  end 
end

# Article opperational tasks & methods.
module ActsAsArticle
  def article?
    return true
  end
  def image?
    return false
  end
end

# Image opperational tasks & methods.
module ActsAsImage
  def image?
    return true
  end
  def article?
    return false
  end
end

# Agent should be the only non-worker that ever touches the DB. Agent is also responsable for DB maintenience tasks both system defined as well as rake-task based via the 'Agency' module.
class Agent
  include Agency
  def initialize
  end
end


# Libraian indexes & manages content.
class Librarian < Agent
  def self.index
    #puts "indexing articles..."
    @index = []
    Dir["./articles/*.md"].each do |f|
      article = File.read(f).split("---\n")
      meta = YAML::load(article[0])
      @index.push({
        :title => meta[:title],
        :section => meta[:section],
        :created_at => File.ctime(f),
        :updated_at => File.mtime(f),
        :tags => meta[:tags].split(', ').each { |t| t.to_sym}, 
        :type => :article,
        :weight => meta[:weight],
        :body => article[1]
      })
    end 
    return @index
  end
  
  def self.encode(articles = Librarian.index)
    articles.each do |a|
      #article = Article.new
      #article.created_at = a[:created_at]
      #article.updated_at = a[:updated_at]
      #article.type = a[:type]
      #article.weight = a[:weight]
      #article.body = a[:body]
      #article.save
      
      Article.create(
        :created_at => a[:created_at],
        :updated_at => a[:updated_at],
        #:tags => nil,
        #:type => a[:type],
        :title => a[:title],
        :section => a[:section],
        :weight => a[:weight],
        :body => a[:body],
      )
      puts "encodeing item #{a[:title]}"
    end
  end
end

## Database Magic ##

module Taggable
  include DataMapper::Resource
  is :remixable, :suffix => "tag"

  property :id, Serial
  property :name, Text
end

# DObject is a common root object to be inherited from by all objects requireing persistance to the DB. DObject deffines common opperational tasks for the various model objects.
class DObject
  include DataMapper::Resource
  include Operations
  
  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime
  property :type, Discriminator
  #Section keyword should be implemented as either a Flag[] or Enum[] property with a default value of 'unsorted' or something to indicate its current status. A state machiene may be viable for tracking changes ond attacting hooks.
  property :section, Text, :lazy => true
  
  #before a DObject is saved its appropriate module is conditionaly included.
  before :save do
    if self.type == Article
      self.class.send(:include, ActsAsArticle)
    elsif self.type == Image || EmbededImage
      self.class.send(:include, ActsAsImage)
    end
  end
  
end

class Article < DObject
  #include ActsAsArticle
  remix n, :taggables, :as => "tags"
  
  property :title, Text
  property :section, Text
  property :weight, Integer
  property :body, Text

  has n, :embeded_images, :through => Resource

  def images
    self.embeded_images
  end
end

class Image < DObject
  include ActsAsImage
  remix n, :taggables, :as => "tags"
  
  property :title, Text
  property :caption, Text
  property :data, Text
end

class EmbededImage < Image
  include ActsAsImage
  remix n, :taggables, :as => "tags"

  has n, :articles, :through => Resource
end

DataMapper.finalize.auto_upgrade!

#Binding.pry #unless ENV['RACK_ENV'].to_sym == :test || :production
__END__

## Page Layouts ##

@@layout
//  %script{:src => "http://cdn.lovely.io/core.js"}
//  -#%script{:src => "/core.js", :type => "text/javascript"}
//  %script{:src => "/application.js", :type => "text/javascript"}
//  %meta{:name => "viewport", :content => "width=device-width, user-scalable=no"}
//  %meta{ :content => "text/html; charset=UTF-8", "http-equiv" => "Content-Type" }
//  %title #{@title}
//  %link{:rel => 'stylesheet', :href => '/style.css'}

doctype html
html
	head
		link rel="stylesheet" href="/style.css"
	body
		== slim :header
		== yield
		== slim :footer


@@header
header
	h1.masthead 
		| I Can Kill You
		br 
		| With My
		br 
		| Brain
	== slim :navigation
	hr
  
@@navigation
nav.navigation
	ul.nav_links
		li.nav_link
			a.left.unicode href="/" ⬡
		li.nav_link 
			a.left.deja href="/blue" Noise
		li.nav_link 
			a.left.deja href="/gold" Contact

@@footer
footer
	small
		p &copy 2013 Gravity Network Services
//  == slim :analytics

@@index
.content
== slim @target

@@red
== slim :articles

@@gold
== slim :articles

@@blue
== slim :articles

@@articles
section.articles
	-@articles.each do |article|
		== slim :article, locals: { article: article}

@@article
article
	section.article_title
		h2.i_am_yellow = article.title unless article.title.nil?
	section.article_body
		== markdown(article.body) unless article.body.nil?

@@images
// p I am @@_images!!

@@image
// p I am @@_image!!

@@tags
// p I am @@_tags!!

//@@analytics
//script
//  | var _gaq=[['_setAccount','UA-38958517-1'],['_trackPageview']];
//  | (function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
//  | g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
//  | s.parentNode.insertBefore(g,s)}(document,'script'));
