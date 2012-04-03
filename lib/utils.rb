module Utils
  module BookmarkUtils
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
end
