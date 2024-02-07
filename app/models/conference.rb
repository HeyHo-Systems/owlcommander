# frozen_string_literal: true

class Conference < ApplicationRecord
  belongs_to :twilio_account
  scope :search_twilio_account_id, ->(id) { where(twilio_account_id: id) }
  has_many :calls, dependent: :nullify

  include SearchCop

  search_scope :search_any do
    attributes :sid,
               :friendly_name,
               :status,
               :reason_conference_ended
    attributes account: 'twilio_account.name'
  end


  def self.search(terms)
    all.then do |scope|
      scope = scope.search_any(terms.search_all) if terms.search_all.present?
      scope = scope.search_twilio_account_id(terms.twilio_account_id) if terms.twilio_account_id.present?
      scope
    end
  end

  def self.upsert_from_twilio(obj)
    conference = where(sid: obj.sid, twilio_account_id: obj.twilio_account_id).first_or_initialize

    return :no_change if conference[:twilio_date_updated] == obj.attributes_for_conference[:twilio_date_updated]

    conference.update!(
      obj.attributes_for_conference
    )

    self.update_calls(obj, conference)
    :changed
  end




  def self.update_calls(obj, conference)
    # we have the info of participants only when they are live, so we mark them as belonging to the conference
    Call
        .where(sid: obj.participants)
        .update_all(conference_id:conference.id)
  end



  def new?
    created_at > 5.minutes.ago
  end

end
