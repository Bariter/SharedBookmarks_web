require 'rubygems'
require 'data_mapper'
require 'sinatra'
require 'json'
require 'date'
require 'uri'
require 'lib/config'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, MyConfig.connect_to) 
DataMapper::Model.raise_on_save_failure = true

enable :logging

require 'lib/database'
require 'lib/data_manipulation'

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

=begin
# Returns the associated user info with id.
get '/:id' do
  @userinfo = Userinfo.get(params[:id])
  p "uid: #{@userinfo.uid}, gender: #{@userinfo.gender}, date_created: #{@userinfo.date_created}, date_updated: #{@userinfo.date_updated}"
end
=end

=begin
# This route is called after '/add_user' and should not allow to be called directly.
get '/id/to_json' do
  content_type :json
  @uid = session[:uid]
  403 if @uid.nil? || @uid.empty

  `echo "@uid: #{p @uid}" >> tmp.log`
  `echo "ret: #{p ret}" >> tmp.log`
  JSON.generate(:uid => @uid)
end 
=end

=begin
# :id is uid of requested user
post '/:id/bookmark' do
  request.body.rewind
  data = JSON.parse(request.body.read)
end
=end

# Adds a user with data supplied and returns the created uid.
post '/add_user' do
  request.body.rewind
  data = JSON.parse(request.body.read)
=begin
data = JSON.parse(URI.unescape(request.body.read))
arydata = URI.unescape(request.body.read).split("&")
@data = []
arydata.each do |a| 
    @data.push(*(a.split("=")))
end
#puts "arydata: #{arydata}"
data = Hash[*@data].to_json
=end
  `echo "in post /add_user" >> tmp.log`
  `echo "data: #{data}" >> tmp.log`
  DataManipulation.check_add_user(data)
  @uid = DataManipulation.add_user(data)

#puts "@uid: #{@uid}"
 
  JSON.generate(:uid => @uid)
end

