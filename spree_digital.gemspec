Gem::Specification.new do |s|
  s.platform     = Gem::Platform::RUBY
  s.name         = 'spree_digital'
  s.version      = '4.1.0'
  s.summary      = ''
  s.description  = 'Digital download functionality for spree'
  s.authors      = ['funkensturm', 'Michael Bianco']
  s.email        = ['info@cliffsidedev.com']
  s.homepage     = 'http://www.funkensturm.com'
  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'
  s.required_ruby_version = '>= 2.1.0'

  spree_version =  '>= 3.1.0', '< 5.0'
  s.add_dependency 'spree_api', spree_version
  s.add_dependency 'spree_backend', spree_version
  s.add_dependency 'spree_core', spree_version
  s.add_dependency 'spree_frontend', spree_version
  s.add_runtime_dependency 'spree_extension'
  s.add_dependency 'deface', '~> 1.0'

  # test suite
  s.add_development_dependency 'spree_dev_tools'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'rspec-activemodel-mocks'
  s.add_development_dependency 'rb-fsevent'
end
