ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
require 'database_cleaner'
require 'ffaker'
require 'shoulda-matchers'

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f }

require 'spree/testing_support/factories'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/url_helpers'

Dir[File.join(File.dirname(__FILE__), "factories/*.rb")].each {|f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::TestingSupport::UrlHelpers
  config.include Spree::TestingSupport::ControllerRequests
  config.use_transactional_fixtures = false

  config.before(:each) do
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation, { :except => ['spree_countries', 'spree_zones', 'spree_zone_members', 'spree_states', 'spree_roles'] }
    else
      DatabaseCleaner.strategy = :transaction
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
    # reset_spree_preferences
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end