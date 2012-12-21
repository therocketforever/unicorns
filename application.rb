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

## Database Magic ##

class DObject
  include DataMapper::Resource
  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime
  property :type, Discriminator
  property :section, String, :lazy => true
  property :tags, Object
end

class Article < DObject
  property :title, String
  property :body, Text

  has n, :embeded_images, :through => Resource

  def images
    self.embeded_images
  end
end

class Image < DObject
  property :title, String
  property :caption, Text
  property :data, Text
end

class EmbededImage < Image
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
