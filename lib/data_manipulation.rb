require 'date'

module DataManipulation
  # TODO:currently, auth_id allows only emails.
  # Set true for necessary propeties. Otherwise, put false.
  @add_user_property = {
    "email" => true,
    "passwd" => true,
    "age" => true,
    "gender" => true,
    "occupation" => false}
  @add_bookmark_property = {
    "uid" => true,
    "name" => true,
    "url" => true,
    "description" => false}

  class Error < StandardError; end

  # When received JSON data contains invalid property name
  class InvalidPropError < Error; end
  # When received JSON data contains invalid format value for some prop.
  class InvalidFormatError < Error; end

  # Property patterns.
  # Each of received data needs to match these patterns.
  EMAIL = /.+@{1}.+/
  AGE = /[0-9]+/

  class << self
    def check_add_user(data)
      @add_user_property.each do |prop, required|
        value = data[prop]

        if required && value.nil? || value.to_s.empty?
          raise(InvalidPropError, "for #{prop}: #{value}")
        end

        check = true 
        case prop
        when "email"
          # should have only one "@" in the middle of string.
          check = EMAIL =~ value
        when "passwd"
          # do nothing for now: it may contain anything.
          # TODO: Should add length and strength checks.
        when "age"
          # Value should be digits and its length should less than three.
          # Assuming the value is an Integer class.
          check = AGE =~ value.to_s && value.to_s.length <= 3
        when "gender"
          check = value.downcase.match('m|f')? true:false
        when "occupation"
          # TODO: do nothing for now.
          check = true
        else
          # When we reache here, something is wrong.
        end

        raise(InvalidFormatError, "for #{prop}: #{value}") unless check
      end
    end

    def add_user(data)
      user = {
        :age => data["age"].to_i,
        :gender => data["gender"],
        :occupation => data["occupation"],
        :accounts => [{
             :auth_id => data["email"],
             :passwd => data["passwd"]}]}

      begin
        Userinfo.create(user)
      rescue => e
        puts "error occured in add_user!! e: #{e}"
      end

      ret = ""
      Userinfo.all(Userinfo.accounts.auth_id => data["email"]).each do |v|
        ret = v.uid.to_s
      end
      ret
    end

    def check_add_bookmark(data)
      @add_bookmark_property.each do |prop, required|
        value = data[prop.to_s]

        if required && value.nil? || value.to_s.empty?
          raise(InvalidPropError, "#{prop}: #{value}")
        end

        check = true 
        case prop
        when "uid"
          check = /[1-9]+/ =~ value.to_s
        when "name"
          # anything can be true for now...
          check = true
        when "url"
          check = URI.regexp =~ value.to_s
        when "description"
          # anything can be true for now...
          check = true
        else
          # When we reach here, something is wrong.
        end

        raise(InvalidFormatError, "for #{prop}: #{value}") unless check
      end
    end

    def add_bookmark(uid, data)
      bookmark = {
        "name" => data["name"],
        "url" => data["url"].to_s,
        "description" => data["description"],
        "validity" => true}

      user = Userinfo.get(uid)

      url = Url.get(bookmark["url"])
      if(url.nil?)
        #The url has not existed in the database yet, so add one.
        url = Url.create(
          "url" => data["url"].to_s,
          "add_count" => 1)
      else
        #If the url has already existed, just increment the count.
        url.update("add_count" => url.add_count + 1)
      end

      book = user.bookmarks.create(bookmark)

      if(book.saved?)
        book.bid
      else
        #TODO: 
        #failed to save the bookmark, so should raise an exception.
      end
    end
  end

end 
