# frozen_string_literal: true

class TwilioCall
  def initialize(twilio_api_call:, twilio_account:)
    @twilio_account = twilio_account
    @twilio_api_call = twilio_api_call
  end

  delegate :id, to: :twilio_account, prefix: true
  delegate :sid,
           :status,
           :direction,
           :duration,
           :queue_time,
           to: :twilio_api_call

  def attributes_for_call # rubocop:disable Metrics/AbcSize
    {
      sid:,
      twilio_account_id: twilio_account.id,
      from_app_id: from_app&.id,
      to_app_id: to_app&.id,
      from_number_id: from_number&.id,
      to_number_id: to_number&.id,
      from_phone: twilio_api_call.from,
      to_phone: twilio_api_call.to,
      status:,
      direction:,
      duration:,
      queue_time: twilio_api_call.queue_time,
      account_sid: twilio_api_call.account_sid,
      parent_sid: twilio_api_call.parent_call_sid,
      root_call_created_at: compute_root_call_created_at
    }.merge(timestamps)
  end

  private

  def timestamps
    {
      started_at: twilio_api_call.start_time,
      ended_at: twilio_api_call.end_time,
      twilio_date_created: twilio_api_call.date_created,
      twilio_date_updated: twilio_api_call.date_updated
    }
  end

  def compute_root_call_created_at
    if twilio_api_call.parent_call_sid
      parent_call = Call.find_by(sid: twilio_api_call.parent_call_sid, twilio_account_id: twilio_account.id)
      return parent_call.root_call_created_at if parent_call
    end

    twilio_api_call.date_created
  end

  def from_app
    twilio_account
      .apps
      .where(sid: twilio_api_call.from).first
  end

  def to_app
    twilio_account
      .apps
      .where(sid: twilio_api_call.to).first
  end

  def from_number
    twilio_account
      .numbers
      .where(phone: twilio_api_call.from).first
  end

  def to_number
    twilio_account
      .numbers
      .where(phone: twilio_api_call.to).first
  end

  attr_reader :twilio_account, :twilio_api_call
end
