# frozen_string_literal: true

class TwilioNumber
  def initialize(twilio_api_number:, twilio_account:, last_synced:)
    @twilio_account = twilio_account
    @twilio_api_number = twilio_api_number
    @last_synced = last_synced
  end

  delegate :id, to: :twilio_account, prefix: true
  delegate :sid,
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
           :status,
           to: :twilio_api_number

  def attributes_for_number # rubocop:disable Metrics/MethodLength
    {
      sid:,
      phone: phone_number,
      name: friendly_name,
      address_sid:,
      bundle_sid:,
      identity_sid:,
      status_url: twilio_api_number.status_callback,
      status_method: twilio_api_number.status_callback_method,
      voice_url:,
      voice_method:,
      voice_fallback_url:,
      voice_fallback_method:,
      sms_url:,
      sms_method:,
      sms_fallback_url:,
      sms_fallback_method:,
      twilio_created_at: date_created,
      twilio_updated_at: date_updated,
      twilio_account_id: twilio_account.id,
      last_synced:,
      status:
    }
  end

  private

  attr_reader :twilio_account, :twilio_api_number, :last_synced
end
