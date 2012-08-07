ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f }

require 'spree/core/testing_support/factories'
require 'spree/core/testing_support/env'
require 'spree/core/testing_support/controller_requests'
require 'spree/core/url_helpers'

RSpec.configure do |config|
  config.mock_with :rspec
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true

  config.include Spree::Core::UrlHelpers
  config.include Spree::Core::TestingSupport::ControllerRequests
  config.include Devise::TestHelpers, :type => :controller
end

Dir[File.join(File.dirname(__FILE__), "factories/*.rb")].each {|f| require f }

# not sure if this really adds anything, but this existed in the intial version of the spree_digital rspec testing
RSpec::Matchers.define :have_valid_factory do |factory_name|
  match do |model|
    FactoryGirl.create(factory_name).new_record?.should be_false
  end
end