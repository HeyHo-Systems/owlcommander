# frozen_string_literal: true

TwilioApiNumber = Struct.new(
  :sid,
  :phone_number,
  :account_sid,
  :friendly_name,
  :address_sid,
  :bundle_sid,
  :identity_sid,
  :sms_application_sid,
  :status_callback,
  :status_callback_method,
  :voice_url,
  :voice_method,
  :voice_fallback_url,
  :voice_fallback_method,
  :sms_url,
  :sms_method,
  :sms_fallback_url,
  :sms_fallback_method,
  :date_created,
  :date_updated,
  :status
)

FactoryBot.define do
  factory :twilio_api_number do
    sid { random_sid('PH') }
    phone_number { generate(:phone) }
    account_sid { random_sid('AC') }
    friendly_name { 'Random Twilio Number' }
    address_sid { random_sid('AD') }
    bundle_sid { random_sid('BU') }
    identity_sid { random_sid('RI') }
    sms_application_sid { random_sid('SMS_APP_') }
    status_callback { random_callback_url(:status) }
    status_callback_method { 'POST' }
    voice_url { random_callback_url(:voice) }
    voice_method { 'POST' }
    voice_fallback_url { random_callback_url(:voice_fallback) }
    voice_fallback_method { 'POST' }
    sms_url { random_callback_url(:sms) }
    sms_method { 'POST' }
    sms_fallback_url { random_callback_url(:sms_fallback) }
    sms_fallback_method { 'POST' }
    date_created { Time.zone.today }
    date_updated { Time.zone.today }
    status { 'in-use' }

    skip_create
  end
end
