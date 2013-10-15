# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dm-soap-adapter/version'

Gem::Specification.new do |spec|
  spec.name          = "dm-soap-adapter"
  spec.version       = SoapAdapter::VERSION
  spec.authors       = ["AnyPresence"]
  spec.email         = ["info@anypresence.com"]
  spec.summary       = "DM adapter for SOAP based data sources."
  spec.homepage      = "https://github.com/AnyPresence/dm-soap-adapter"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency "httpclient",     "~> 2.1.5.2"
  spec.add_dependency "data_objects",   "~> 0.10.13"
      
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
