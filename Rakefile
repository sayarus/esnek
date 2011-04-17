require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require './lib/esnek/version'


spec = eval(File.read('esnek.gemspec'))
    
Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = false
  p.need_zip = false
end

Rake::RDocTask.new do |rdoc|
  files =['README.rdoc', 'LICENSE','CHANGES', 'AUTHORS', 'lib/**/*.rb', 'test/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README"
  rdoc.title = "Esnek Documentation"
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.options
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*.rb']
end

