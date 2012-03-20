class Account
  include DataMapper::Resource

  # Primary key
  property :auth_id, String, :key => true

  property :passwd, String, :required => true
  property :active, Boolean, :default => true
  property :date_created, DateTime, :required => true
  property :date_updated, DateTime, :required => true
  
  # Foreign key
  belongs_to :userinfo
end

class Userinfo
  include DataMapper::Resource

  # Primary key
  property :uid, Serial

  property :age, Integer, :required => true 
  # store "m" for male, "f" for female 
  property :gender, String, :required => true
  property :occupation, String, :required => true
  property :date_created, DateTime, :required => true
  property :date_updated, DateTime, :required => true

  has n, :accounts

  def values
    [uid, gender, occupation, date_created, date_updated]
  end
end

class Bookmark
  include DataMapper::Resource

  # Primary key
  property :markid, Serial

  property :name, String, :required => true
  property :url, URI, :required => true
  property :description, String
  # This default of validity should be changed to check dynamically when data is added.
  property :validity, Boolean, :required => true, :default => true
  property :date_created, DateTime, :required => true
  property :date_updated, DateTime, :required => true

  belongs_to :userinfo
end

DataMapper.finalize
