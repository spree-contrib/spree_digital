source 'http://rubygems.org'

group :test do
  # without ffaker in test it wont init
  # https://github.com/spree/spree/pull/833
  gem 'ffaker'
  gem 'shoulda-matchers'
  gem 'guard-rspec'
  
  if RUBY_PLATFORM.downcase.include? "darwin"
    gem 'rb-fsevent'
    gem 'growl'
  end
end

gemspec
