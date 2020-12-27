source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'rails', '6.0.3.1'
gem 'sqlite3', '1.4.2'
gem 'puma', '~> 3.11'
gem 'active_model_serializers', '~> 0.10.10'
gem 'interactor-initializer', '~> 0.2.0'
gem 'jquery-rails'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '3.2.1'
  gem 'spring', '2.1.0'
  gem 'spring-watcher-listen', '2.0.1'
end

group :test do
  gem 'capybara', '3.34.0'
  gem 'capybara-screenshot', '1.0.25'
  gem 'dotenv', '2.7.6'
  gem 'rails-controller-testing', '1.0.5'
  gem 'rspec-rails', '4.0.1'
  gem 'json_spec', '1.1.5'
  gem 'factory_bot_rails', '~> 5.2'
  gem 'selenium-webdriver', '3.142.7'
  gem 'database_cleaner', '1.8.5'
end
