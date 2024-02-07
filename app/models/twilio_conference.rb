# frozen_string_literal: true

class TwilioConference
  def initialize(twilio_api_conference:, twilio_account:)
    @twilio_account = twilio_account
    @twilio_api_conference = twilio_api_conference
  end

  delegate :id, to: :twilio_account, prefix: true
  delegate :sid,
           :status,
           :account_sid,
           :friendly_name,
           :reason_conference_ended,
           :date_created,
           :date_updated,
           :call_sid_ending_conference,
           to: :twilio_api_conference

  def attributes_for_conference
    {
      sid:,
      twilio_account_id: twilio_account.id,
      account_sid:,
      status:,
      friendly_name:,
      reason_conference_ended:,
      twilio_date_created: date_created,
      twilio_date_updated: date_updated,
      call_sid_ending_conference:,
    }
  end

  def participants
    twilio_api_conference.participants.list.map(&:call_sid)
  end

  private

  attr_reader :twilio_account, :twilio_api_conference
end

