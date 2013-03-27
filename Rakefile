#ENV['RACK_ENV'] = 'development'

require 'bundler'

if ENV['RACK_ENV'].nil? then ENV['RACK_ENV'] = "development" end

case rack_env = ENV['RACK_ENV']
  when rack_env.to_sym == :production
    Bundler.require(:default, :production)
  when rack_env.to_sym == :test
    Bundler.require(:default, :development, :test)
  when rack_env == nil
    Bundler.require(:default, :development)
  else
    Bundler.require(:default, :development)
end

require File.join(File.dirname(__FILE__), 'application.rb')

#require_relative 'application'
#require 'pry'

#librarian = Librarian.new

namespace :development do
  task :deploy do
    Rake::Task["development:clean"].invoke
    Rake::Task["development:encode"].invoke
    #Rake::Task["development:article_encode"].invoke
    #Rake::Task["development:image_encode"].invoke
  end
  
  task :encode do
    puts "I am the Encoder!"
    Rake::Task["development:articles_index"].invoke
    Librarian.encode
  end
  
  task :clean do
    puts "Removeing Previous Data..."
    Article.all.destroy
  end
  
  task :articles_index do
    puts "I am the Article Indexer"
    Librarian.index
  end
  
  task :images_encode do
    puts "I am the Image encoder"
    librarian.encode
  end
end
