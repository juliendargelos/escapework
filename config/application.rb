require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Escapework
  class Application < Rails::Application
    config.exceptions_app = self.routes
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/*.{rb,yml}').to_s]
    config.i18n.locale = :fr
    config.i18n.default_locale = :fr
    config.generators.javascript_engine = :js
    config.sass.preferred_syntax = :sass
  end
end
