ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "spec_helper"
require "rspec/rails"
require "capybara/rspec"
# Add additional requires below this line. Rails is not loaded until this point!
require 'helpers/session_helpers'
# Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Capybara.register_driver :headless_chrome do |app|
  
  driver_path = ENV['CHROMEDRIVER_PATH']

  raise 'CHROMEDRIVER_PATH is required for running JS specs but is undefined in ENV' unless driver_path

  service = Selenium::WebDriver::Service.new(path: driver_path, port: 9005)
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')

  Capybara::Selenium::Driver.new(app, browser: :chrome, service: service, options: options)
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include Helpers::SessionHelpers, type: :feature

end

Capybara.default_driver = :headless_chrome
Capybara.javascript_driver = :headless_chrome