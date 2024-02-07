# frozen_string_literal: true

class CreateApps < ActiveRecord::Migration[7.0]
  def change
    create_table :apps do |t|
      t.references :twilio_account, null: false, foreign_key: true
      t.string :name
      t.string :sid
      t.timestamp :last_synced
      t.timestamp :twilio_created_at
      t.timestamp :twilio_updated_at

      t.timestamps
    end
  end
end
