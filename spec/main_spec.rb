require File.dirname(__FILE__) + '/../spec/spec_helper'

describe '/user' do
  before :each do
    # cleanup the test db.
    `rake db:migrate`
    @data = JSON.generate(:age => 19, :gender => 'f', :occupation => 'student', :email => "test@nowhere.net", :passwd => "mypassword")
    @data2 = JSON.generate(:age => 19, :gender => 'f', :occupation => 'student', :email => "test2@nowhere.net", :passwd => "mypassword")
  end

  it 'should return the uid of the added user' do
    post '/user', @data

    ret = last_response.body
    ret_json = JSON.parse(ret)
    ret_json.should include "uid"
  end

  it 'should return different uid when two users are added in a row' do
    # first user added
    begin
      post '/user', @data
      ret = last_response.body
      ret_json = JSON.parse(ret)
      ret_json.should include "uid"
    rescue => e
      puts "Error in adding the first user: #{e}"
      return false
    end

    # second user added
    begin
      post '/user', @data2
      ret2 = last_response.body
      ret_json2 = JSON.parse(ret2)
      ret_json2.should include "uid"
    rescue => e
      puts "Error in adding the second user: #{e}"
      return false
    end

    puts "ret: #{ret}"
    puts "ret2: #{ret2}"
    
    ret_json2.should_not == ret_json
  end

end
