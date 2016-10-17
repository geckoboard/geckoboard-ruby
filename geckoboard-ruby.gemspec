# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geckoboard/version'

Gem::Specification.new do |spec|
  spec.name          = 'geckoboard-ruby'
  spec.version       = Geckoboard::VERSION
  spec.authors       = ['Daniel Upton']
  spec.email         = %w[daniel.upton@geckoboard.com]

  spec.summary       = %q{Ruby client library for Geckoboard}
  spec.homepage      = 'https://github.com/geckoboard/geckoboard-ruby'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'webmock', '~> 2.1'
  spec.add_runtime_dependency 'rest-client', '~> 2.0.0'
end
