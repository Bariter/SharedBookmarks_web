$: << File.dirname(__FILE__)
$stdout.sync = true

require 'rubygems'
require 'main.rb'
run Sinatra::Application
