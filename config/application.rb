require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Trade
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.app_generators.scaffold_controller :responders_controller

    config.time_zone = 'Moscow'

    config.responders.flash_keys = [ :success, :warning ]
    config.i18n.default_locale = :ru

    unless ENV['TEAMCITY_PROJECT_NAME']
     config.active_record.schema_format = :sql
    end

    config.autoload_paths += Dir[
      "#{Rails.root}/app/form_objects",
      "#{Rails.root}/app/inputs",
      "#{Rails.root}/app/errors",
      "#{Rails.root}/app/inputs",
      "#{Rails.root}/app/services",
      "#{Rails.root}/app/commands"
    ]
    # Settings in config/environments/* take precedence over those specified here.
  end
end
