# frozen_string_literal: true

class CreateConferences < ActiveRecord::Migration[7.0]
  def change
    create_table :conferences do |t|
      t.string :sid
      t.string :friendly_name

      t.references :twilio_account, null: false, foreign_key: true
      t.string :account_sid

      t.datetime :date_created
      t.datetime :date_updated

      t.string :status
      t.string :reason_conference_ended
      t.string :call_sid_ending_conference

      t.timestamps
    end
  end
end
