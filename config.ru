require 'rubygems'
require 'bundler'

Bundler.require

use Rack::Codehighlighter, :coderay, :markdown => true,
  :element => "pre>code", :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i, :logging => false
    
require './application'
run Application
