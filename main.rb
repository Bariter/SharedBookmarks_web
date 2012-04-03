require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'date'
require 'uri'

require 'lib/config'
require 'lib/database'
require 'lib/data_manipulation'
require 'lib/utils'

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

#TODO: Need to add filter to check login status

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

# TODO
# This is for testing purpose only.
get '/bookmark' do
  p Bookmark.all
end

=begin
helpers do
  def generate_return_bookmark(uid, bookmark)
    {
      :uid => uid,
      :bid => bookmark["bid"],
      :name => bookmark["name"],
      :url => bookmark["url"],
      :description => bookmark["description"],
      :created_at => bookmark["created_at"],
      :updated_at => bookmark["updated_at"]
    }
  end
end
=end

# Returns all the bookmarks associated with :uid in JSON format.
get '/:uid/bookmark' do
  helpers Utils::BookmarkUtils

  @uid = params[:uid]
  bookmarks = Userinfo.get(@uid).bookmarks.all
  
  result = {:bookmark => []}
  bookmarks.each do |bookmark|
    result[:bookmark] << generate_return_bookmark(@uid, bookmark)
  end

  JSON.generate(result)
end

# This route adds a bookmark.
# :uid takes the uid of the requested user. 
post '/:uid/bookmark' do
  request.body.rewind
  data = JSON.parse(request.body.read)

  @uid = params[:uid]
  DataManipulation.check_add_bookmark(data)
  @bid = DataManipulation.add_bookmark(@uid, data)

  JSON.generate(:uid => @uid, :bid => @bid)
end

# This route adds a user with data supplied and returns the created uid.
post '/user' do
  request.body.rewind

  data = JSON.parse(request.body.read)
  DataManipulation.check_add_user(data)
  @uid = DataManipulation.add_user(data)

  JSON.generate(:uid => @uid)
end
