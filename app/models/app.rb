# frozen_string_literal: true

class App < ApplicationRecord
  belongs_to :twilio_account

  def self.upsert_from_twilio(obj)
    app = where(sid: obj.sid, twilio_account_id: obj.twilio_account_id).first_or_initialize

    app.update!(
      obj.attributes_for_application
    )
  end
end
