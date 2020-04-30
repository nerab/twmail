# -*- encoding: utf-8 -*-
# frozen_string_literal: true

require 'English'
require File.expand_path('../lib/twmail/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Nicholas E. Rabenau']
  gem.email         = ['nerab@gmx.net']
  gem.description   = 'Mail new tasks to your TaskWarrior inbox'
  gem.summary       = 'Use fetchmail and the scripts in this project to mail tasks to your local TaskWarrior installation'
  gem.homepage      = 'https://github.com/nerab/TaskWarriorMail'

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'twmail'
  gem.require_paths = ['lib']
  gem.version       = TaskWarriorMail::VERSION

  gem.add_dependency 'mail'

  gem.add_development_dependency 'twtest', '~> 1.2.0'
  gem.add_development_dependency 'guard-test'
  gem.add_development_dependency 'guard-bundler'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rubocop'
end
