# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'esnek/version'

Gem::Specification.new do |s|
  s.name = 'esnek'
  s.version = ESNEK_VERSION
  s.extra_rdoc_files = ['README.rdoc', 'LICENSE','CHANGES','AUTHORS']
  s.summary = 'Esnek provides a minimalistic Ruby interface for JSON  APIs, such as ElasticSearch'
  s.description = s.summary
  s.authors = ['Alper Akgun']
  s.email = 'esnek@sayarus.com'
  s.homepage = "https://github.com/sayarus/esnek"
  s.license       = "MIT"
  s.files = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.bindir = "bin"
  s.add_dependency("json", ">= 1.4")
  s.add_dependency("rest-client", ">= 1.6.1")
  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rake", "~> 10.0"
end
