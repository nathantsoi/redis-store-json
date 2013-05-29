# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "redis/actionpack/version"

Gem::Specification.new do |s|
  s.name        = 'redis-actionpack-json'
  s.version     = Redis::ActionPack::VERSION
  s.authors     = ["Nathan Tsoi", "Luca Guidi", "Matt Horan"]
  s.email       = ["nathan@vertile.com"]
  s.homepage    = "http://github.com/nathantsoi/redis-store-json"
  s.summary     = "Rails 4 Redis session store for ActionPack with JSON serialization"
  s.description = "Rails 4 Redis session store for ActionPack with JSON serialization"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'redis-store-json', '~> 3.0.0'
  s.add_runtime_dependency 'redis-rack-json',  '~> 1.5.2'
  s.add_runtime_dependency 'actionpack',  '~> 4.0.0.rc1'

  s.add_development_dependency 'rake',     '~> 10'
  s.add_development_dependency 'bundler',  '~> 1.2'
  s.add_development_dependency 'mocha',    '~> 0.13.0'
  s.add_development_dependency 'minitest', '~> 4.3.1'
  s.add_development_dependency 'tzinfo'
  s.add_development_dependency 'mini_specunit'
  s.add_development_dependency 'mini_backtrace'
end
