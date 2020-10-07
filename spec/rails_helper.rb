require 'spec_helper'
require 'factory_bot_rails'
require 'json_spec'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Schema.verbose = false
load "#{Rails.root.to_s}/db/schema.rb"

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
  config.include JsonSpec::Helpers

  config.before(:each, type: :request) do
    host! 'localhost:3000'
  end
end
