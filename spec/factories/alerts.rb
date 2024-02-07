# frozen_string_literal: true

FactoryBot.define do
  factory :alert do
    twilio_account
    call { nil }
    sid { random_sid('NO') }
    message { 'This is an alert' }
    request_url { 'https://example.com/twilio' }
    request_method { 'POST' }
    error_code { 'MyString' }
    resource_sid { random_sid('CA') }
    twilio_created_at { Time.zone.now }
  end
end
