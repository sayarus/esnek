Gem::Specification.new do |s|
  s.name = 'esnek'
  s.version = ESNEK_VERSION
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc', 'LICENSE','CHANGES','AUTHORS']
  s.summary = 'Esnek provides a quick Ruby interface for JSON  APIs, such as ElasticSearch'
  s.description = s.summary
  s.author = 'Alper Akgun'
  s.email = 'esnek@sayarus.com'
  s.homepage = "https://github.com/sayarus/esnek"
  #s.executables = ['devrinim']
  s.files = %w(LICENSE README.rdoc Rakefile AUTHORS CHANGES) + Dir.glob("{bin,lib,spec, rdoc}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
  s.add_dependency("json", "~> 1.5.1")
  s.add_dependency("rest-client", "~> 1.6.1")
end
