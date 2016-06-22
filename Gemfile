source 'https://rubygems.org'

gem 'spree', github: 'spree/spree', branch: '3-1-stable'

gemspec

group :test do
  if RUBY_PLATFORM.downcase.include? "darwin"
    gem 'guard-rspec'
    gem 'rb-fsevent'
    gem 'growl'
  end
end
