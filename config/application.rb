require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'attachinary/orm/active_record'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AmazingcodersRails
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # load service layer
    config.autoload_paths += Dir["#{config.root}/app/services/**/"]
    config.action_mailer.asset_host = 'http://localhost:3000.com'
    
    # set default time zone
    config.time_zone = 'Singapore'
    config.active_record.default_timezone = :local

    # load api helpers
    config.autoload_paths += Dir["#{config.root}/lib"]
    config.autoload_paths += Dir["#{config.root}/lib/burpple"]

    # Override field_with_error class
    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      html_tag
    }

  end
end
