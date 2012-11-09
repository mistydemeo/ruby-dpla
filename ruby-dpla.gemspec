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
end
