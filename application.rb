## Database Magic ##

class DObject
  include DataMapper::Resource
  property :id, Serial
end

DataMapper.finalize

## Website ##
class Application < Sinatra::Base
  
  enable :logging, :inline_templates
  
  configure :test do
  end
  
  configure :development do
    DataMapper.setup(:default, "sqlite://#{Dir.pwd}/development.db")
  end
  
  configure :production do
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
%p Hello from a Haml Template!!

@@weblog

@@about

@@portfolio

@@contact

@@_articles

@@_article
