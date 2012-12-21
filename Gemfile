source :rubygems

gem "sinatra", :require => "sinatra/base"
gem "thin"
gem "data_mapper", :require => "data_mapper"

gem "haml", :require => "haml"
gem "sass", :require => "sass"
gem "redcarpet", :require => "redcarpet"

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
  gem "dm-postgres-adapter", :require => "dm-postgres-adapter"
end
