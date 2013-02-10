Gem::Specification.new do |s|
  s.platform     = Gem::Platform::RUBY
  s.name         = 'spree_digital'
  s.version      = '1.1.1'
  s.summary      = ''
  s.description  = 'Digital download functionality for spree'
  s.authors      = ['funkensturm', 'Michael Bianco']
  s.email        = ['info@cliffsidedev.com']
  s.homepage     = 'http://www.funkensturm.com'
  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'
  s.required_ruby_version = '>= 1.8.7'

  s.add_dependency 'spree_core', '~> 1.3.0'

  # test suite
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails', '~> 1.7.0'
  s.add_development_dependency 'rspec-rails', '~> 2.8'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'database_cleaner'
end