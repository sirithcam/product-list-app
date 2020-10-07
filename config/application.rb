require 'rails'
require 'rails/all'

require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)

module ProductListApp
  class Application < Rails::Application
    config.load_defaults 5.2

    config.autoload_paths += [
      "#{config.root}/app/serializers",
    ]
  end
end
