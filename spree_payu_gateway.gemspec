# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_payu_gateway/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_payu_gateway'
  s.version     = SpreePayuGateway.version
  s.summary     = 'Add extension summary here'
  s.description = 'Add (optional) extension description here'
  s.required_ruby_version = '>= 2.2.7'

  s.author    = 'HunnyJummani'
  s.email     = 'hunny.jummani@botreetechnologies.com'
  s.homepage  = 'https://github.com/HunnyJummani/spree_payu_gateway'
  s.license = 'BSD-3-Clause'

  s.files       = `git ls-files`.split("\n").reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  s.require_path = 'lib'
  s.requirements << 'none'

  spree_version = '>= 3.2.0', '< 5.0'
  s.add_dependency 'spree_core', spree_version
  s.add_dependency 'spree_api', spree_version
  s.add_dependency 'spree_backend', spree_version
  s.add_dependency 'spree_extension'
  s.add_dependency 'config'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-screenshot'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'postgresql'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec-rails', '~> 4.0.0.beta2'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'webdrivers'
  s.add_development_dependency 'webmock'
end
