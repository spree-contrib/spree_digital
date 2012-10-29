ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f }

require 'spree/core/testing_support/factories'
require 'spree/core/testing_support/env'
require 'spree/core/testing_support/controller_requests'
require 'spree/core/url_helpers'

Dir[File.join(File.dirname(__FILE__), "factories/*.rb")].each {|f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include Spree::Core::UrlHelpers
  config.include Spree::Core::TestingSupport::ControllerRequests
  config.include Devise::TestHelpers, :type => :controller

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
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

# not sure if this really adds anything, but this existed in the intial version of the spree_digital rspec testing
RSpec::Matchers.define :have_valid_factory do |factory_name|
  match do |model|
    FactoryGirl.create(factory_name).new_record?.should be_false
  end
end