require 'rspec/rails'
require 'spec_helper'
require 'factory_bot_rails'
require 'json_spec'
require 'database_cleaner'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }
Dir[Rails.root.join('spec/helpers/**/*.rb')].sort.each { |f| require f }
Dir[Rails.root.join('spec/shared_examples/**/*.rb')].sort.each { |f| require f }

Rails.env = ENV['RAILS_ENV']
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: "#{Rails.root}/db/test.sqlite3")
ActiveRecord::Schema.verbose = false
load "#{Rails.root}/db/schema.rb"

ActiveSupport::Deprecation.silenced = true

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
  config.include JsonSpec::Helpers

  config.before(:each, type: :request) do
    host! 'localhost:3000'
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :truncation
  end

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
