require_relative 'app'
require 'rake/testtask'
require 'resque/tasks'
require 'securerandom'

Rake::TestTask.new do |t|
  t.test_files = FileList['test.rb']
end
desc "Run tests"

task :generate_token do
  puts SecureRandom.hex(20)
end

task default: :test
