require 'dm-timestamps'

class Account
  include DataMapper::Resource

  # Primary key
  property :auth_id, String, :key => true

  property :passwd, String, :required => true
  property :active, Boolean, :default => true
  property :created_at, DateTime
  property :updated_at, DateTime
  
  # Foreign key
  belongs_to :userinfo
end

class Userinfo
  include DataMapper::Resource

  attr_reader :uid

  # Primary key
  property :uid, Serial, :key => true

  property :age, Integer, :required => true 
  # store "m" for male, "f" for female 
  property :gender, String, :required => true
  property :occupation, String, :required => true
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :accounts
  has n, :bookmarks

  def values
    [uid, gender, occupation, date_created, date_updated]
  end
end

class Bookmark
  include DataMapper::Resource

  attr_reader :bid, :url

  # Primary key
  property :bid, Serial, :key => true

  property :name, String, :required => true
  property :url, URI, :required => true
  property :description, String
  # This default of validity should be changed to check dynamically when data is added.
  property :validity, Boolean, :required => true, :default => true
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :userinfo
end

class Url
  include DataMapper::Resource

  attr_reader :url, :add_count

  # Primary key
  property :url, URI, :key => true

  property :validity, Boolean, :required => true, :default => true
  # add_count will be changed whenever user delete or add bookmark
  property :add_count, Integer, :required => true
  property :created_at, DateTime
  property :updated_at, DateTime
end

DataMapper.finalize
