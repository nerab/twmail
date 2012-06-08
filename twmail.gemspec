# -*- encoding: utf-8 -*-
require File.expand_path('../lib/twmail/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nicholas E. Rabenau"]
  gem.email         = ["nerab@gmx.net"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "twmail"
  gem.require_paths = ["lib"]
  gem.version       = TaskWarriorMail::VERSION
  
  gem.add_dependency 'mail', '~> 2.4'
  gem.add_dependency 'activesupport', '~> 3.2'
  gem.add_dependency 'json', '~> 1.7'
end
