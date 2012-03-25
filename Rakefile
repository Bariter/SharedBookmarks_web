require 'rubygems'
require 'data_mapper'
require 'rspec/core'
require 'rspec/core/rake_task'

$:.unshift( File.join(File.dirname(__FILE__)), "lib")
require 'config'
require 'database'

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

task 'spec' => ['db:migrate','spec_all']

desc 'Run all spec in /spec dir...'
RSpec::Core::RakeTask.new(:spec_all)
