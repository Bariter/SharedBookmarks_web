require File.dirname(__FILE__) + '/../spec/spec_helper'

describe 'POST' do
  before :each do
    # cleanup the database before testing
    # TODO: there maybe better way to do this.
    DataMapper.auto_migrate!
  end

  describe '/user' do
    it 'should return the uid of the added user' do
      post '/user', sample_user("testuser1@nowhere.com").to_json

      ret_json = last_response.body
      ret = JSON.parse(ret_json)

      ret.should_not be_nil
      ret["uid"].should_not be_nil
      ret["uid"].should_not be_empty
    end

    it 'should return different uid when two users are added in a row' do
      # Adding first user
      post '/user', sample_user("testuser1@nowhere.net").to_json

      ret_json = last_response.body
      first_user = JSON.parse(ret_json)

      # Adding second user
      post '/user', sample_user("testuser2@nowhere.net").to_json

      ret_json = last_response.body
      second_user = JSON.parse(ret_json)

      # the returnd uid should be different
      first_user["uid"].should_not == second_user["uid"]
    end

  end

  describe '/:uid/bookmark' do
    it 'should return bid and uid in JSON format' do
      post '/user', sample_user("testuser1@nowhere.net").to_json
      ret_json = last_response.body
      user = JSON.parse(ret_json)

      post "/#{user["uid"]}/bookmark", sample_bookmark.to_json

      result = last_response.body

      result.should include "bid"
      result.should include "uid"

      expect {
        JSON.parse(result)
      }.to_not raise_error
    end
  end

describe 'GET'
  describe '/:uid/bookmark' do
    it 'should return all the bookmarks for the user in JSON format' do
      # Add a sample user.
      post '/user', sample_user("testuser1@nowhere.net").to_json
      ret_json = last_response.body
      user = JSON.parse(ret_json)

      # Add two different bookmarks.
      post "/#{user["uid"]}/bookmark", sample_bookmark("http://aa.com").to_json
      post "/#{user["uid"]}/bookmark", sample_bookmark("http://bb.com").to_json

      # Retrieve all the bookmarks for this user.
      get "/#{user["uid"]}/bookmark"
      bookmarks = last_response.body

      # Make sure the result is in JSON format
      expect {
        bookmarks = JSON.parse(bookmarks)
      }.to_not raise_error

      # Make sure the result has everything.
      bookmarks["bookmark"].size.should == 2
    end
  end

end
