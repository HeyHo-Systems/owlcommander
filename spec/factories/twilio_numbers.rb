# frozen_string_literal: true

FactoryBot.define do
  factory :twilio_number do
    twilio_account
    twilio_api_number

    initialize_with { new(twilio_api_number:, twilio_account:, last_synced: Time.zone.now) }
    skip_create
  end
end
