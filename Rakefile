$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'data_mapper'
require 'lib/config'
require 'lib/database'

desc 'Migrate Database'
task 'db:migrate' do
  puts 'Migrating Database...'
  DataMapper.setup(:default, MyConfig.connect_to)
  DataMapper.auto_migrate!
end 

desc 'Upgrade Database'
task 'db:upgrade' do
  puts 'Upgrading Database'
  DataMapper.setup(:default, MyConfig.connect_to)
  DataMapper.auto_upgrade!
end

desc 'Run all spec in /spec dir...'
task 'rspec' => ['db:migrate','spec']

task 'spec' do
  puts 'Running rspec...'
  sh('rspec')
end
