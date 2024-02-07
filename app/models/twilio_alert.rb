# frozen_string_literal: true

class TwilioAlert
  def initialize(twilio_api_alert:, twilio_account:)
    @twilio_account = twilio_account
    @twilio_api_alert = twilio_api_alert
  end

  delegate :id, to: :twilio_account, prefix: true
  delegate :sid,
           :account_sid,
           :alert_text,
           :error_code,
           :request_url,
           :request_method,
           :resource_sid,
           :date_created,
           to: :twilio_api_alert

  def attributes_for_alert
    {
      sid:,
      call:,
      message:,
      request_url:,
      request_method:,
      error_code:,
      resource_sid:,
      twilio_created_at: date_created,
      twilio_account_id: twilio_account.id
    }
  end

  def message
    Rack::Utils.parse_nested_query(alert_text)['Msg']
  end

  def call
    return nil unless resource_sid.start_with?('CA')

    twilio_account.calls.find_by(sid: resource_sid)
  end

  private

  attr_reader :twilio_account, :twilio_api_alert
end
