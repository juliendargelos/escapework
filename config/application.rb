require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Escapework
  class Application < Rails::Application
    config.exceptions_app = self.routes
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/*.{rb,yml}').to_s]
    config.i18n.default_locale = ENV.key?('DEFAULT_LOCALE') ? ENV.fetch('DEFAULT_LOCALE') : :en
    config.generators.javascript_engine = :js
    config.sass.preferred_syntax = :sass
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
