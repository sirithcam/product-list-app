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
  gem 'rspec-rails', '4.0.1'
  gem 'json_spec', '1.1.5'
  gem 'factory_bot_rails', '~> 5.2'
end
