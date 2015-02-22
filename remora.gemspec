# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'remora/version'

Gem::Specification.new do |spec|
  spec.name          = "remora"
  spec.version       = Remora::VERSION
  spec.authors       = ["Evan R"]
  spec.email         = ["eunoia.github+remora@gmail.com"]
  spec.description   = %q{ Get stats on San Franscisco real estate }
  spec.summary       = %q{ Lightweight gem to discover information about San Francisco real estate via Property Shark. Can be adapted for anywhere in California. }
  spec.homepage      = "http://github.com/eunoia/remora"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "rspec-nc", "~> 0.0", ">= 0.0.6"
  spec.add_development_dependency "guard", "~> 2.6"
  spec.add_development_dependency "guard-rspec", "~> 4.2"
  spec.add_development_dependency "pry", "~> 0.9", ">= 0.9.12.6"
  spec.add_development_dependency "pry-remote", "~> 0.1", ">= 0.1.8"
  spec.add_development_dependency "pry-nav", "~> 0.2", ">= 0.2.3"

  spec.add_runtime_dependency "mechanize", "~>2.7"
  spec.add_runtime_dependency "nokogiri", "~>1.6"

  spec.requirements << "an account at propertyshark"
end
