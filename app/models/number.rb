# frozen_string_literal: true

class Number < ApplicationRecord
  belongs_to :twilio_account
  has_many :inbound_calls,  inverse_of: :to_number,
                            class_name: 'Call',
                            dependent: :nullify,
                            foreign_key: :to_number_id
  has_many :outbound_calls, inverse_of: :from_number,
                            class_name: 'Call',
                            dependent: :nullify,
                            foreign_key: :from_number_id
  validates :sid, presence: true, uniqueness: { scope: :twilio_account_id }

  scope :search_phone, ->(q) { ilike(phone: q) }
  scope :search_name, ->(q) { ilike(name: q) }
  scope :search_sid, ->(q) { ilike_prefix(sid: q) }
  scope :search_voice_url, ->(q) { ilike(voice_url: q) }
  scope :search_twilio_account_id, ->(id) { where(twilio_account_id: id) }
  scope :search_account_name, ->(q) { where(twilio_account_id: TwilioAccount.search_name(q)) }

  def self.search_any(term)
    scope = joins(twilio_account: :account)
    scope
      .search_phone(term)
      .or(scope.search_name(term))
      .or(scope.search_sid(term))
      .or(scope.search_voice_url(term))
      .or(scope.search_account_name(term))
  end

  def self.search(terms)
    all.then do |scope|
      scope = scope.search_all(terms.search_all) if terms.search_all.present?
      scope = scope.search_twilio_account_id(terms.twilio_account_id) if terms.twilio_account_id.present?
      scope = scope.search_voice_url(terms.voice_url) if terms.voice_url.present?
      scope
    end
  end

  def update_and_persist_to_twilio(attributes)
    transaction do
      assign_attributes(attributes)
      if changed?
        save!
        twilio_number.update(friendly_name: name)
      end
    end
  end

  def twilio_number
    twilio_account.client.incoming_phone_numbers(sid)
  end

  def self.upsert_from_twilio(obj)
    number = where(sid: obj.sid, twilio_account_id: obj.twilio_account_id).first_or_initialize

    number.update!(
      obj.attributes_for_number
    )
  end
end
