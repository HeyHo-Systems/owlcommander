# frozen_string_literal: true

FactoryBot.define do
  factory :app do
    twilio_account
    sequence(:name) { |n| "Application #{n}" }
    sid { random_sid('AP') }
    last_synced { Time.zone.now }
    twilio_created_at { Time.zone.now }
    twilio_updated_at { Time.zone.now }
  end
end
