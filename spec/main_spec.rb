require File.dirname(__FILE__) + '/../spec/spec_helper'

describe 'POST' do
  before :all do
    # cleanup the database before testing
    DataMapper.auto_migrate!
  end

  describe '/user' do
    it 'should return the uid of the added user' do
      post '/user', sample_user.to_json

      ret_json = last_response.body
      ret = JSON.parse(ret_json)

      ret.should_not be_nil
      ret["uid"].should_not be_nil
      ret["uid"].should_not be_empty
    end

    it 'should return different uid when two users are added in a row' do
      # Adding first user
      sample_user1 = JSON.parse(sample_user.to_json)
      sample_user1["email"] = "testuser1@nowhere.net"
      post '/user', sample_user1.to_json

      ret_json = last_response.body
      first_user = JSON.parse(ret_json)

      # Adding second user
      sample_user2 = JSON.parse(sample_user.to_json)
      sample_user2["email"] = "testuser2@nowhere.net"

      post '/user', sample_user2.to_json

      ret_json = last_response.body
      second_user = JSON.parse(ret_json)

      # the returnd uid should be different
      first_user["uid"].should_not == second_user["uid"]
    end

  end

  describe '/:id/bookmark' do
    it 'should return bid and uid in JSON format' do
      post '/3/bookmark', sample_bookmark.to_json

      result = last_response.body

      result.should include "bid"
      result.should include "uid"

      expect {
        JSON.parse(result)
      }.not_to raise_error
    end
  end

end
