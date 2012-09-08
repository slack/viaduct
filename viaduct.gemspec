# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'viaduct/version'

Gem::Specification.new do |gem|
  gem.name          = "viaduct"
  gem.version       = Viaduct::VERSION
  gem.authors       = ["Jason Hansen"]
  gem.email         = ["jhansen@slack.io"]
  gem.description   = "Build stuff with middlware."
  gem.summary       = "Extracted from vagrant, viaduct makes it easy to build up middlware."
  gem.homepage      = "https://github.com/slack/viaduct"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "rspec", "~> 2.10.0"
end
