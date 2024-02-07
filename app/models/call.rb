# frozen_string_literal: true
require 'csv'

class Call < ApplicationRecord
  belongs_to :twilio_account
  belongs_to :from_app, class_name: 'App', optional: true
  belongs_to :from_number, class_name: 'Number', optional: true
  belongs_to :to_app, class_name: 'App', optional: true
  belongs_to :to_number, class_name: 'Number', optional: true

  # The conference association is optional because not all calls are part of a conference
  belongs_to :conference, class_name: 'Conference', optional: true
  has_many :alerts, dependent: :nullify

  scope :search_twilio_account_id, ->(id) { where(twilio_account_id: id) }

  include SearchCop

  search_scope :search_any do
    attributes :sid,
               :duration,
               :direction,
               :status,
               :started_at,
               :ended_at,
               :queue_time,
               :parent_sid
    attributes date: 'root_call_created_at'
    attributes from: %w[from_phone]
    attributes to: %w[to_phone to_app.name to_number.name]
    attributes account: 'twilio_account.name'
    attributes conference_name: 'conference.friendly_name'
    attributes conference_sid: 'conference.sid'
  end

  def friendly_direction
    return 'Outbound API' if direction == 'outbound-api'

    direction.to_s.humanize.titleize
  end

  def from_app?
    from_phone.to_s.start_with?('AP')
  end

  def to_app?
    to_phone.to_s.start_with?('AP')
  end

  def from_app_name
    return nil unless from_app?

    from_app&.name || 'Unknown application'
  end

  def to_app_name
    return nil unless to_app?

    to_app&.name || 'Unknown application'
  end

  def self.search(terms)
    all.then do |scope|
      scope = scope.search_any(terms.search_all) if terms.search_all.present?
      scope = scope.search_twilio_account_id(terms.twilio_account_id) if terms.twilio_account_id.present?
      scope
    end
  end

  def self.upsert_from_twilio(obj)
    call = where(sid: obj.sid, twilio_account_id: obj.twilio_account_id).first_or_initialize

    return :no_change if call[:twilio_date_updated] == obj.attributes_for_call[:twilio_date_updated]

    call.update!(
      obj.attributes_for_call
    )
    :changed
  end

  def new?
    created_at > 8.seconds.ago
  end

  def self.to_csv(calls)
    CSV.generate(headers: true) do |csv|
      csv << Call.attribute_names
      calls.each do |call|
        csv << call.attributes.values_at(*Call.attribute_names)
      end
    end
  end

  # Used to group calls in the view
  attribute :follower, default: false
  attribute :followed, default: false
end
