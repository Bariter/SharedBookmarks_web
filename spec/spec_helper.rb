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

  def sample_user(email = "bariter@gmail.com", pass = "mypasswd", age = 20,
      gender = "M", occup = "Student")
    {
      "email" => email,
      "passwd" => pass,
      "age" => age,
      "gender" => gender,
      "occupation" => occup
    }
  end

  def sample_bookmark(url = "http://kkas.hatenablog.com/",
    name = "my favorite blog", desc = "thin is my faborite blog", uid = 1)
    {
      "uid" => uid,
      "url" => url,
      "name" => name,
      "description" => desc
    }
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
