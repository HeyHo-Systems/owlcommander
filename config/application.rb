# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

def fetch_secret(name)
  ENV.fetch(name) do
    raise "Missing secret #{name}" unless ENV['IGNORE_MISSING_SECRETS'].to_s == 'true'
  end
end

module OwlCommander
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.active_record.encryption.primary_key = fetch_secret('ENCRYPTION_PRIMARY_KEY')
    config.active_record.encryption.deterministic_key = fetch_secret('ENCRYPTION_DETERMINISTIC_KEY')
    config.active_record.encryption.key_derivation_salt = fetch_secret('ENCRYPTION_KEY_DERIVATION_SALT')
    config.action_mailer.default_url_options = { host: ENV.fetch('BASE_URL', 'owl-commander.herokuapp.com') }
    config.action_mailer.default_options = { parts_order: ['text/plain'] }
    config.action_dispatch.rescue_responses['Pundit::NotAuthorizedError'] = :forbidden

    config.active_job.queue_adapter = :delayed_job
    config.active_job.logger = Logger.new(STDOUT)
    config.active_job.logger.level = Logger::DEBUG
  end
end
