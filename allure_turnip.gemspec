# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "allure_turnip/version"

Gem::Specification.new do |s|
  s.name          = 'allure_turnip'
  s.version       = AllureTurnip::Version::STRING
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['aha-oretama']
  s.email         = ['sekine_y_529@msn.com']
  s.description   = %q{Adaptor to use Allure framework along with the Turnip}
  s.summary       = "allure_turnip-#{AllureTurnip::Version::STRING}"
  s.homepage      = 'https://github.com/aha-oretama/allure_turnip'
  s.license       = 'Apache-2.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'rspec', '~> 3.5'
  s.add_dependency 'allure-ruby-adaptor-api', '0.7.0'
  s.add_dependency 'turnip', '~> 3.0'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
end
