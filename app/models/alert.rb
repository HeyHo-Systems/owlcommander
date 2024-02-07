# frozen_string_literal: true

class Alert < ApplicationRecord
  belongs_to :twilio_account
  belongs_to :call, optional: true

  scope :search_message, ->(q) { ilike(message: q) }
  scope :search_sid, ->(q) { ilike_prefix(sid: q) }
  scope :search_resource_sid, ->(q) { ilike_prefix(resource_sid: q) }
  scope :search_request_url, ->(q) { ilike(request_url: q) }
  scope :search_request_method, ->(q) { ilike(request_method: q) }
  scope :search_error_code, ->(q) { ilike_prefix(error_code: q) }
  scope :search_twilio_account_id, ->(id) { where(twilio_account_id: id) }
  scope :search_account_name, ->(q) { where(twilio_account_id: TwilioAccount.search_name(q)) }

  def self.search_any(term)
    scope = joins(twilio_account: :account)
    scope
      .search_message(term)
      .or(scope.search_sid(term))
      .or(scope.search_resource_sid(term))
      .or(scope.search_error_code(term))
      .or(scope.search_request_url(term))
      .or(scope.search_request_method(term))
      .or(scope.search_account_name(term))
  end

  def self.search(terms)
    all.then do |scope|
      scope = scope.search_all(terms.search_all) if terms.search_all.present?
      scope = scope.search_twilio_account_id(terms.twilio_account_id) if terms.twilio_account_id.present?
      scope
    end
  end

  def self.upsert_from_twilio(obj)
    alert = where(sid: obj.sid, twilio_account_id: obj.twilio_account_id).first_or_initialize

    alert.update!(
      obj.attributes_for_alert
    )
  end

  def new?
    created_at > 5.minutes.ago
  end
end
