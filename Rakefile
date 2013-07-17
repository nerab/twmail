#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  ENV['PATH'] = "./bin:#{ENV['PATH']}" # prefer the local bin path
  test.libs << 'lib' << 'test' << 'test/helpers'
  test.test_files = FileList['test/**/test_*.rb']
end

task :default => :test
