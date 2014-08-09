require './lib/esnek/version'
RUBY_ENGINE = 'ruby' unless defined? RUBY_ENGINE
source 'https://rubygems.org' unless ENV['QUICK']
gemspec

gem 'rake'
if RUBY_ENGINE == "ruby" and RUBY_VERSION > '1.9.2'
gem 'rest-client'
gem 'json'
gem "minitest", "~> 4.0"
gem 'rdoc'
end

