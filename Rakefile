require 'rake'
require 'rake/testtask'

desc 'run tests'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => [:test]