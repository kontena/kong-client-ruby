# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kong/version'

Gem::Specification.new do |spec|
  spec.name          = "kong-client"
  spec.version       = Kong::VERSION
  spec.authors       = ["Lauri Nevala"]
  spec.email         = ["lauri@kontena.io"]
  spec.summary       = %q{A Ruby client for the Kong API }
  spec.description   = %q{A Ruby client for the Kong API}
  spec.homepage      = "https://github/kontena/kong-client-ruby"
  spec.license       = "Apache-2.0"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.0.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "excon", "~> 0.49.0"
end
