## Website ##
class Application < Sinatra::Base
  
  enable :logging, :inline_templates

  configure :test do
    DataMapper.setup(:default, "sqlite://#{Dir.pwd}/features/support/test.db")
  end
 
  configure :development do
    Bundler.require(:development)
    DataMapper.setup(:default, "sqlite://#{Dir.pwd}/development.db")
  end

  configure :production do
    #ENV['DATABASE_URL'] || DataMapper.setup(:default, "sqlite://#{Dir.pwd}/development.db") 
  end

  helpers do
    def evaluate_path
     @target = case request.path
        when '/red'
          :_red
        when '/blue'
          :_blue
        when '/gold'
          :_gold
        else
          :_red
      end
    end
  end

  get "/style.css" do
    content_type 'text/css', :charset => 'utf-8'
    scss :style
  end

  get "/" do
    @title = "therocketforever"
    @articles = Article.all :order => :weight.asc
    evaluate_path
    haml :index
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
        :created_at =>  File.ctime(f),
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
  property :name, String
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
  property :section, String, :lazy => true
  
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
  
  property :title, String
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
  
  property :title, String
  property :caption, Text
  property :data, Text
end

class EmbededImage < Image
  include ActsAsImage
  remix n, :taggables, :as => "tags"

  has n, :articles, :through => Resource
end

DataMapper.finalize.auto_upgrade!

Binding.pry unless ENV['RACK_ENV'].to_sym == :test
__END__

## Page Layouts ##

@@layout
!!! 5
%head
  %title #{@title}
  %link{:rel => 'stylesheet', :href => '/style.css'}
%body
  = yield

@@_header

@@_navigation

@@index
%p I am Index!!
.content 
  = haml @target

@@_red
%p I am @@_red!!
= haml :_articles

@@_gold
%p I am @@_gold!!

@@-blue
%p I am @@_blue!!

@@_articles
%p I am @@_articles!!
%section.articles
  - @articles.each do |article|
    = haml :_article, :locals => {:article => article}

@@_article
%article
  %p I am @@_article!!
  %h3= article.title
  = markdown(article.body)

@@_images
%p I am @@_images!!

@@_image
%p I am @@_image!!

@@_tags
%p I am @@_tags!!
