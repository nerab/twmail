# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'
RuboCop::RakeTask.new

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test' << 'test/helpers'
  test.test_files = FileList['test/**/test_*.rb']
end

task default: %i[rubocop test]
