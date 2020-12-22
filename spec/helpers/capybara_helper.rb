Capybara.configure do |config|
  include DriversHelper

  config.default_driver = ENV['BROWSER'].to_sym

  config.app_host = 'localhost:3001'

  config.server_port = 3001

  config.run_server = true

  config.save_path = 'log/screenshots'
  
  config.server = :puma, { Silent: true }
end

Capybara::Screenshot.register_driver(ENV['BROWSER'].to_sym) do |driver, path|
  driver.browser.save_screenshot(path)
end
