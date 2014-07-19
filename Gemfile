source 'https://rubygems.org'

gem 'spree', github: 'spree/spree', branch: 'master'

gemspec

group :test do
  if RUBY_PLATFORM.downcase.include? "darwin"
    gem 'guard-rspec'
    gem 'rb-fsevent'
    gem 'growl'
  end
end
