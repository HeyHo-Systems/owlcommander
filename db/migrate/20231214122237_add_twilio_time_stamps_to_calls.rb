# frozen_string_literal: true

class AddTwilioTimeStampsToCalls < ActiveRecord::Migration[7.0]
  def change
    # We add two new fields that track the twilio created/updated timestamps.
    change_table :calls, bulk: true do |t|
      t.datetime :twilio_date_created
      t.datetime :twilio_date_updated
    end
    # this might take a while
    # rubocop:disable Rails::SkipsModelValidations
    Call.update_all('twilio_date_created = started_at, twilio_date_updated = started_at')
    # rubocop:enable Rails::SkipsModelValidations

    rename_column :conferences, :date_created, :twilio_date_created
    rename_column :conferences, :date_updated, :twilio_date_updated
  end
end
