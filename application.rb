## Website ##
class Application < Sinatra::Base
  
  enable :logging, :inline_templates

  configure :test do
    DataMapper.setup(:default, "sqlite://#{Dir.pwd}/development.db")
  end
 
  configure :development do
    Bundler.require(:development)
    DataMapper.setup(:default, "sqlite://#{Dir.pwd}/development.db")
  end

  configure :production do
    #ENV['DATABASE_URL'] || 
  end

  get "/style.css" do
    content_type 'text/css', :charset => 'utf-8'
    scss :style
  end

  get "/" do
    @title = "therocketforever"
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

class Agent
  include Agency
  def initialize
  end
end

## Database Magic ##

module Taggable
  include DataMapper::Resource
  is :remixable, :suffix => "tag"

  property :id, Serial
  property :name, String
end

class DObject
  include DataMapper::Resource
  include Operations
  
  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime
  property :type, Discriminator
  property :section, String, :lazy => true
end

class Article < DObject
  remix n, :taggables, :as => "tags"
  
  property :title, String
  property :body, Text

  has n, :embeded_images, :through => Resource

  def images
    self.embeded_images
  end
end

class Image < DObject
  remix n, :taggables, :as => "tags"
  
  property :title, String
  property :caption, Text
  property :data, Text
end

class EmbededImage < Image
  remix n, :taggables, :as => "tags"

  has n, :articles, :through => Resource
end

DataMapper.finalize.auto_migrate!

Binding.pry
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

@@command
% I am @@command!!

@@operations
%p I am @@operations!!

@@science
%p I am @@science!!

@@_articles
%p I am @@_articles!!

@@_article
%p I am @@_article!!

@@_images
%p I am @@_images!!

@@_image
%p I am @@_image!!

@@_tags
%p I am @@_tags!!
