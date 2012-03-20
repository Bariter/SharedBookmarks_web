$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), ".."))
require 'main.rb'
require 'json'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

module MyTestMethods
  set :show_exceptions, false

  def app
    Sinatra::Application
  end
end
 
RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include MyTestMethods
end
