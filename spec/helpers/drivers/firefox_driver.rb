Capybara.register_driver :firefox do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.args << '--headless' if ENV.fetch('HEADLESS', '1') == '1'

  Capybara::Selenium::Driver.new(
    app,
    browser: :firefox,
    options: options
  )
end
