# frozen_string_literal: true

class CreateNumbers < ActiveRecord::Migration[7.0]
  def change
    create_table :numbers do |t|
      t.references :twilio_account, null: false, foreign_key: true
      t.string :name
      t.string :phone
      t.string :sid
      t.string :address_sid
      t.string :bundle_sid
      t.string :identity_sid
      t.string :status_url
      t.string :status_method
      t.string :voice_url
      t.string :voice_method
      t.string :voice_fallback_url
      t.string :voice_fallback_method
      t.string :sms_url
      t.string :sms_method
      t.string :sms_fallback_url
      t.string :sms_fallback_method
      t.timestamp :last_synced
      t.timestamp :twilio_created_at
      t.timestamp :twilio_updated_at

      t.timestamps
    end
  end
end
