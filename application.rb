class Application < Sinatra::Base
  
  enable :logging, :inline_templates

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
