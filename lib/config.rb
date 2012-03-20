module MyConfig
  class << self
    def connect_to
      ENV['DATABASE_URL'] || 'sqlite3:db.sqlite3'
    end
  end
end
