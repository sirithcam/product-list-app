Capybara.configure do |config|
  include DriversHelper

  config.default_driver = ENV['BROWSER'].to_sym

  config.app_host = 'localhost:3000'

  config.save_path = 'log/screenshots'
end

Capybara::Screenshot.register_driver(ENV['BROWSER'].to_sym) do |driver, path|
  driver.browser.save_screenshot(path)
end
