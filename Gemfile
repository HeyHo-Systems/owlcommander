# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'rails', '~> 7.1.3'

gem 'bootsnap', require: false
gem 'pg', '~> 1.4'
gem 'puma', '~> 6.0'

gem 'cssbundling-rails'
gem 'jsbundling-rails'
gem 'propshaft'

gem 'devise'
gem 'http'
gem 'jbuilder'
gem 'pagy'
gem 'pundit'
gem 'rollbar'
gem 'search_cop'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'twilio-ruby'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'pundit-matchers'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-discourse', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
end

gem 'matrix'

gem 'delayed_job_active_record', '~> 4.1'

gem "daemons", "~> 1.4"
