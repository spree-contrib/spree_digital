Gem::Specification.new do |s|
  s.platform     = Gem::Platform::RUBY
  s.name         = 'spree_digital'
  s.version      = '1.0.0'
  s.summary      = ''
  s.description  = 'This gem is supposed to be used in connection with spree_core. It was tested with spree_core 0.66.99 but it might work with newer versions as well.'
  s.author       = 'funkensturm.'
  s.homepage     = 'http://www.funkensturm.com'
  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'
  s.required_ruby_version = '>= 1.8.7'
  s.add_dependency('spree_core', '~> 1.0.0')

  # test suite
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sqlite3'
end