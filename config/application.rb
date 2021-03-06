require File.expand_path('../boot', __FILE__)

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)



module SureCrm1
  class Application < Rails::Application
    #config.encoding = "utf-8"
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers

    config.autoload_paths += %W(#{config.root}/lib) # add this line to include modules
    # Autoload lib/ folder including all subdirectories
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    
    #config.autoload_paths += %W(#{config.root}/lib/mod) # add this line
    # -- all .rb files in that directory are automatically loaded.
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    #config.active_record.default_timezone = :local
     #config.time_zone = 'Mumbai'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    #config.assets.initialize_on_precompile = false

    config.active_record.raise_in_transactional_callbacks = true
  end
end
