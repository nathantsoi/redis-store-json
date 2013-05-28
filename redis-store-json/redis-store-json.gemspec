# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'redis/store/version'

Gem::Specification.new do |s|
  s.name        = 'redis-store-json'
  s.version     = Redis::Store::VERSION
  s.authors     = ["Nathan Tsoi", "Luca Guidi", "Matt Horan"]
  s.email       = ["nathan@vertile.com"]
  s.homepage    = "http://github.com/nathantsoi/redis-store-json"
  s.summary     = "Rails 4 Redis session store for ActionPack with JSON serialization"
  s.description = "Rails 4 Redis session store for ActionPack with JSON serialization"

  s.rubyforge_project = 'redis-store-json'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'redis', '~> 3.0.0'

  s.add_development_dependency 'rake',     '~> 10'
  s.add_development_dependency 'bundler',  '~> 1.2'
  s.add_development_dependency 'mocha',    '~> 0.13.0'
  s.add_development_dependency 'minitest', '~> 4.3.1'
  s.add_development_dependency 'git',      '~> 1.2.5'
end

