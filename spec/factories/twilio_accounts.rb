# frozen_string_literal: true

FactoryBot.define do
  factory :twilio_account do
    account
    sequence(:name) { |n| "Twilio Account #{n}" }
    account_sid { random_sid('AC') }
    api_key { 'an-api-key' }
    api_key_secret { 'a-super-secret' }
  end
end
