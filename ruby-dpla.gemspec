# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby-dpla/version'

Gem::Specification.new do |gem|
  gem.name          = "ruby-dpla"
  gem.version       = DPLA::VERSION
  gem.authors       = ["Misty De Meo"]
  gem.email         = ["mistydemeo@gmail.com"]
  gem.description   = %q{Use DPLA in your app!}
  gem.summary       = %q{Use DPLA in your app!}
  gem.homepage      = "https://github.com/mistydemeo/ruby-dpla"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'httparty', '>= 0.9.0'
  gem.add_dependency "activesupport"
  
  gem.add_development_dependency "bundler",      "~> 1.0"
  gem.add_development_dependency "shoulda"
  gem.add_development_dependency "mocha",        "~> 0.13"
  gem.add_development_dependency "minitest",     "~> 2.12"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "turn",        "~> 0.9"
  gem.add_development_dependency "webmock"
  
end
