source 'https://rubygems.org'

# Specify your gem's dependencies in dm-soap-adapter.gemspec
gemspec

group :test do
  gem 'rspec',          '~> 2.13.0',    :require => %w(spec)
  gem 'rake'
  
  gem 'bundler',        '~> 1.3.5'
  gem 'ParseTree',                  :require => 'parse_tree'
  gem 'dm-sweatshop'
  gem 'dm-sqlite-adapter'
  
  
  DM_VERSION = '~> 1.2.0'
  gem 'dm-types', DM_VERSION
  gem "dm-core",  DM_VERSION

  gem 'savon', '~> 2.3.0'
  gem "mocha", '~> 0.13', :require => false
  gem 'soap4r', :git => 'git://github.com/felipec/soap4r.git'
end