source :rubygems

gem 'sinatra', '1.1.0'
gem 'thin', '1.2.7'
gem 'datamapper', :require => 'data_mapper'
gem 'dm-postgres-adapter'
gem 'yajl-ruby', :require => ['yajl', 'yajl/json_gem']
gem 'rake'

group :production do
  gem 'pg', '0.10.0'
end

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'dm-sqlite-adapter'
end
