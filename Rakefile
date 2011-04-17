require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require './lib/devrinim/version'

spec = Gem::Specification.new do |s|
  s.name = 'esnek'
  s.version = ESNEK_VERSION
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'LICENSE','CHANGES','AUTHORS']
  s.summary = 'Esnek provides a quick Ruby interface for JSON  APIs, such as ElasticSearch'
  s.description = s.summary
  s.author = 'Alper Akgun'
  s.email = 'esnek@sayarus.com'
  #s.executables = ['devrinim']
  s.files = %w(LICENSE README Rakefile AUTHORS CHANGES) + Dir.glob("{bin,lib,spec, rdoc}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
  s.add_dependency("json", "~> 1.5.1")
  s.add_dependency("rest-client", "~> 1.6.1")
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = false
  p.need_zip = false
end

Rake::RDocTask.new do |rdoc|
  files =['README', 'LICENSE','CHANGES', 'AUTHORS', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README" # page to start on
  rdoc.title = "Devrinim Documentation"
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*.rb']
end

