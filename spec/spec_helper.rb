$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), ".."))
require 'rack/test'
require 'main'
require 'lib/data_manipulation'

ENV['RACK_ENV'] = 'test'
set :environment, :test

module MyTestMethods
  set :show_exceptions, false

  def app
    Sinatra::Application
  end

  def sample_user
      @json_data = {
        'email' => "bariter@gmail.com",
        'passwd' => "mypassword",
        'age' => 20,
        'gender' => "M",
        'occupation' => "Student"}.dup
  end

  def sample_bookmark
      @json_data = {
        'uid' => 3,
        'url' => "http://kkas.hatenablog.com/",
        'name' => "my favorite blog",
        'description' => "this is my favorite blog"}.dup
  end

end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include MyTestMethods

  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end
