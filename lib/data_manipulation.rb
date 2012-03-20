require 'date'

class DataManipulation

  # currently, auth_id allows only emails.
  @add_user_property = %w[email passwd age gender occupation]
  
  class << self
    def check_add_user(data)
      @add_user_property.each do |prop|
        value = data[prop]
        raise "Invalid value: #{prop}" if value.nil? || value.to_s.empty?

        check = true 
        case prop
        when "email"
          # should have only one "@" in the middle of string.
          check = /.+@{1}.+/ === value
        when "passwd"
          # do nothing for now: it may contain anything.
          # TODO: Should add length and strength checks.
        when "age"
          # Is value digit? and l.e. 3?
          # Assuming the value is an Integer class.
          #check = /[0-9]+/ === value.to_s && value.length <= 3
          check = /[0-9]+/ === value.to_s && value.to_s.length <= 3
        when "gender"
          check = value.downcase.match('m|f')? true:false
        when "occupation"
          # do nothing
        end

        raise "invalid value for #{prop}. the value is #{value}. the class is #{value.class}" unless check
      end
    end

    def add_user(data)
      now = DateTime.now
      user = {
        :age => data["age"].to_i,
        :gender => data["gender"],
        :occupation => data["occupation"],
        :date_created => now,
        :date_updated => now,
        :accounts => [
           {
             :auth_id => data["email"],
             :passwd => data["passwd"],
             :date_created => now,
             :date_updated => now 
           }
        ]
      }
      
      begin
        Userinfo.create(user)
      rescue => e
        puts "error occured!! e: #{e}"
      end

      ret = ""
      Userinfo.all(Userinfo.accounts.auth_id => data["email"]).each do |v|
        ret = v.uid.to_s
      end
      puts "ret: #{ret}"
      ret
    end

=begin
    def get_user_by_uid(uid)
      Userinfo.all(Userinfo.accounts.auth_id => data["email"]).each do |v|
    end
=end
  end

end 
