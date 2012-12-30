# -*- encoding: utf-8 -*-
require File.expand_path('../lib/server-registry-client/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael James"]
  gem.email         = ["umjames29@gmail.com"]
  gem.description   = %q{Client library and command-line tools for interacting with the server registry (https://github.com/umjames/server-registry)}
  gem.summary       = %q{Client library and command-line tools for interacting with the server registry (https://github.com/umjames/server-registry)}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "server-registry-client"
  gem.require_paths = ["lib"]
  gem.version       = ServerRegistry::Client::VERSION

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
