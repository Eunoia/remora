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
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "mechanize"
  spec.add_development_dependency "nokogiri"
end
