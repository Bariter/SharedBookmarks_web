$: << File.dirname(__FILE__)
$stdout.sync = true

require 'rubygems'
require 'main'
run Sinatra::Application
