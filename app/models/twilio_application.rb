# frozen_string_literal: true

class TwilioApplication
  def initialize(twilio_api_application:, twilio_account:)
    @twilio_account = twilio_account
    @twilio_api_application = twilio_api_application
  end

  delegate :id, to: :twilio_account, prefix: true
  delegate :sid,
           :account_sid,
           :friendly_name,
           :date_created,
           :date_updated,
           to: :twilio_api_application

  def attributes_for_application
    {
      sid:,
      name: friendly_name,
      twilio_created_at: date_created,
      twilio_updated_at: date_updated,
      twilio_account_id: twilio_account.id
    }
  end

  private

  attr_reader :twilio_account, :twilio_api_application
end
