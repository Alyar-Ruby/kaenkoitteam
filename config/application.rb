require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)
require 'dotenv'
Dotenv.load
module Kaenko
  class Application < Rails::Application
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              ENV['KAENKO_MAILER_ADDRESS'],
      port:                 ENV['KAENKO_MAILER_PORT'],
      domain:               ENV['KAENKO_MAILER_DOMAIN'],
      user_name:            ENV['KAENKO_MAILER_USERNAME'],
      password:             ENV['KAENKO_MAILER_PWD'],
      authentication:       'plain',
      enable_starttls_auto: true  }  

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.active_record.schema_format = :sql
    config.middleware.delete Rack::Lock
    
    config.paths.add "app/api", glob: "**/*.rb"            #For Grape
    config.autoload_paths += Dir["#{Rails.root}/app"]      # For Grape
    config.middleware.use(Rack::Config) do |env|
       env['api.tilt.root'] = Rails.root.join "app", "views", "api"   
    end
  end
end
