# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_filter/version'

Gem::Specification.new do |spec|
  spec.name          = "hash_filter"
  spec.version       = HashFilter::VERSION
  spec.authors       = ["Peter Suschlik"]
  spec.email         = ["ps@neopoly.de"]
  spec.summary       = %q{Filters hashes}
  spec.description   = %q{Simple hash filter}
  spec.homepage      = "https://github.com/neopoly/hash_filter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.3.5"
end
