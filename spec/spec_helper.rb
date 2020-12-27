require File.expand_path('../config/environment', __dir__)
require 'byebug'
require 'dotenv/load'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'selenium/webdriver'
require 'rails-controller-testing'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(type: :feature) { Capybara.page.driver.browser.manage.window.resize_to(1340, 1400) }

  config.append_after { Capybara.reset_sessions! }
end
