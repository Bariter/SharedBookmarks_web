require File.join(File.dirname(__FILE__) , "../spec/spec_helper")

describe 'Database' do
  describe 'Userinfo' do
    it 'should be empty when no user has been added yet.'
    it 'should be only one user when a user is added.'
  end

  describe 'Bookmark' do
    it 'should be empty when no bookmark for a user has been added yet.'
    it 'should be only one bookmark when a bookmark is added.'
  end

  describe 'Url' do
    it 'should be empty when no bookmark for a user has been added yet.'
    it 'should be only one url data when a bookmark is added.'
  end
end
