Capybara.register_driver :safari do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :safari
  )
end
