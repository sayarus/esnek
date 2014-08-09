lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'esnek/version'
require 'rake/testtask'
require "bundler/gem_tasks"

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*.rb']
end

