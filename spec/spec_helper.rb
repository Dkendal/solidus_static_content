require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'ffaker'
require 'rspec/rails'
require 'database_cleaner'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

require 'spree/testing_support/factories'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/capybara_ext'

FactoryGirl.find_definitions

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.mock_with :rspec
  config.use_transactional_fixtures = false

  config.include Spree::TestingSupport::ControllerRequests, type: :controller
  config.include Spree::TestingSupport::UrlHelpers
  config.include FactoryGirl::Syntax::Methods

  config.extend Spree::TestingSupport::AuthorizationHelpers::Request, type: :feature

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = RSpec.current_example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  Capybara.javascript_driver = :poltergeist
end
