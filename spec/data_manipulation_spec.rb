require File.join(File.dirname(__FILE__) , "../spec/spec_helper")

describe DataManipulation do
  before :each do
    DataMapper.auto_migrate!

    # Add test user for test
    Userinfo.count.should eql 0
    user = sample_user
    Userinfo.create(
      :age => user["age"],
      :gender => user["gender"],
      :occupation => user["occupation"])
    Userinfo.count.should eql 1
  end

  describe 'check_add_user' do
    it 'should pass the check when data is good' do
      user_json = sample_user.to_json
      user = JSON.parse(user_json)

      DataManipulation.check_add_user(user).should be_true
    end

    it 'should throw InvalidFormatError when data is not valid format' do
      user_json = sample_user.to_json
      user = JSON.parse(user_json)

      # Create failing data with invalid string.
      # Any data can be used here. We use url for now.
      user["age"] = "Hello World!"
      bad_user = user

      expect do
        DataManipulation.check_add_user(bad_user)
      end.to raise_error DataManipulation::InvalidFormatError
    end
  end

  describe 'check_add_bookmark' do
    it 'should pass the check when data is good' do
      bookmark_json = sample_bookmark.to_json
      bookmark = JSON.parse(bookmark_json)

      DataManipulation.check_add_bookmark(bookmark).should be_true
    end

    it 'should throw InvalidFormatError when data is not valid format' do
      bookmark = JSON.parse(sample_bookmark.to_json)

      # Create failing data with invalid string.
      # Any data can be used here. We use url for now.
      bookmark["url"] = "Hello World!"
      bad_bookmark = bookmark

      expect do
        DataManipulation.check_add_bookmark(bad_bookmark)
      end.to raise_error DataManipulation::InvalidFormatError
    end

    it 'should create url data when new bookmark is added' do
      bookmark = JSON.parse(sample_bookmark.to_json)

      user = Userinfo.get(1)
      user.should_not be_nil

      Url.get(bookmark["url"]).should be_nil

      user.bookmarks.get(1).should be_nil
      DataManipulation.add_bookmark(1, bookmark)
      user.bookmarks.get(1).should_not be_nil

      Url.get(bookmark["url"]).should_not be_nil
    end

    it 'should increment add_count by one when existing bookmark is added' do
      # Add second user to add the same url.
      user = sample_user
      user2 = Userinfo.create(
        :age => user["age"],
        :gender => user["gender"],
        :occupation => user["occupation"])

      Userinfo.count.should == 2

      user = Userinfo.get(1)
      bookmark = JSON.parse(sample_bookmark.to_json)

      DataManipulation.add_bookmark(user.uid, bookmark)
      user.bookmarks.get(1).should_not be_nil

      Url.get(bookmark["url"]).add_count.should == 1

      DataManipulation.add_bookmark(user2.uid, bookmark)
      user.bookmarks.get(1).should_not be_nil

      Url.get(bookmark["url"]).add_count.should == 2
    end
  end

end
