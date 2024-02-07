# frozen_string_literal: true

FactoryBot.define do
  factory :twilio_application do
    twilio_account
    twilio_api_application

    initialize_with { new(twilio_api_application:, twilio_account:) }
    skip_create
  end
end
