source :rubygems

ruby '2.0.0'

gem "sinatra", :require => "sinatra/base"
gem "thin"
gem "data_mapper", :require => "data_mapper"
#gem "dm-sqlite-adapter", :require => "dm-sqlite-adapter"
gem "dm-is-remixable", :require => "dm-is-remixable"

gem "haml", :require => "haml"
gem "slim"
gem "coffee-script"
gem "sass", :require => "sass"
gem "redcarpet", :require => "redcarpet"
gem "barista", "~> 1.0", :require => "barista"

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
