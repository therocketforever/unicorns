source 'https://rubygems.org'

ruby '2.0.0'

gem "sinatra", :require => "sinatra/base"
gem "sinatra-contrib", git: 'https://github.com/sinatra/sinatra-contrib.git', :require => "sinatra/multi_route"
gem "sinatra-advanced-routes", :require => "sinatra/advanced_routes"
gem "thin"
gem "data_mapper", :require => "data_mapper"
gem "dm-is-remixable", :require => "dm-is-remixable"

gem "haml", :require => "haml"
gem "slim", "~> 2.0.0.pre.6"
gem "coffee-script"
gem "sass", :require => "sass"
gem "redcarpet", :require => "redcarpet"
gem "coderay"
gem 'rack-codehighlighter', :require => 'rack/codehighlighter'

group :test do
  gem "cucumber", :require => "cucumber"
  gem "capybara", :require => "capybara"
  gem "capybara", :require => "capybara/cucumber"
  gem "rspec", :require => "rspec"
end

group :development do
  gem "pry", :require => "pry"
  gem "dm-sqlite-adapter", :require => "dm-sqlite-adapter"
end

group :production do
  gem "pg", :require => "pg"
  gem "dm-postgres-adapter", :require => "dm-postgres-adapter"
end
