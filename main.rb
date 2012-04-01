require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'date'
require 'uri'

require 'lib/config'
require 'lib/database'
require 'lib/data_manipulation'

# TODO: this needs to be enabled only if env = test
#DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, MyConfig.connect_to) 
DataMapper::Model.raise_on_save_failure = true

enable :logging

use Rack::Session::Cookie,
  #:key => 'rack.session',
  #:domain => 'foo.com',
  #:path => '/',
  :expire_after => 3600,
  :secret => 'change'

=begin
error do
  "Error!!" + ENV['sinatra.error'].name
end

error do
  "Error!!" 
end

=end

#TODO: need to add filter to check login status

# This route is for testing purpose only.
get '/' do
  myaddress = "test@nowhere.net"

  data = {
    :age => 18,
    :gender => 'm',
    :occupation => "student",
    :email => myaddress,
    :passwd => "this is my password."
  }.to_json

puts "json_data: #{data}"
  begin
    @uid = DataManipulation.add_user(data)
  rescue => e
    puts "error in get '/'. e: #{e}"
  end

  "ok: @uid: #{@uid}" # need this to avoid bytesize error.
end

get '/bookmark' do
  p Bookmark.all
end

# /:uid/bookmark adds bookmark.
# :uid takes the uid of requested user. 
post '/:uid/bookmark' do
#  content_type :json
  request.body.rewind
  data = JSON.parse(request.body.read)
  @uid = params[:uid]
puts "data in bookmark"
p data
  DataManipulation.check_add_bookmark(data)

  @bid = DataManipulation.add_bookmark(@uid, data)
  {:uid => @uid, :bid => @bid}.to_json
end

# Adds a user with data supplied and returns the created uid.
post '/user' do
  request.body.rewind
  data = JSON.parse(request.body.read)
  DataManipulation.check_add_user(data)
  @uid = DataManipulation.add_user(data)
  {:uid => @uid}.to_json
end

