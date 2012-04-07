require 'rubygems'
require 'data_mapper'

#$:.unshift( File.join(File.dirname(__FILE__)), "lib")
$:.unshift("./lib")
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


desc 'Run rspec'
task :spec do
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = %w(-c)
  end
end
task :default => :spec
