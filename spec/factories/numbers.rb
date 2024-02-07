# frozen_string_literal: true

FactoryBot.define do
  factory :number do
    twilio_account
    sequence(:name) { |n| "Number #{n}" }
    phone { generate(:phone) }
    sid { random_sid('PN') }
    address_sid { random_sid('AD') }
    bundle_sid { random_sid('BU') }
    identity_sid { random_sid('RI') }
    status_url { random_callback_url(:status) }
    status_method { 'POST' }
    voice_url { random_callback_url(:voice) }
    voice_method { 'POST' }
    voice_fallback_url { random_callback_url(:voice_fallback) }
    voice_fallback_method { 'POST' }
    sms_url { random_callback_url(:sms) }
    sms_method { 'POST' }
    sms_fallback_url { random_callback_url(:sms_fallback) }
    sms_fallback_method { 'POST' }
    last_synced { Time.zone.now }
    twilio_created_at { Time.zone.now }
    twilio_updated_at { Time.zone.now }
  end
end
