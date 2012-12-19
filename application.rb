class Application < Sinatra::Base
  
  enable :logging

  get "/" do
    "Hello World from the / route!"
  end
end

__END__

@@layout
!!! 5
%head
  %title = @title
  %link{:rel => 'stylesheet', :href => '/style.css'}
%body
  = yield

@@index
%p Hello from a Haml Template!!
