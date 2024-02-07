# frozen_string_literal: true

class CreateAlerts < ActiveRecord::Migration[7.0]
  def change
    create_table :alerts do |t|
      t.references :twilio_account, null: false, foreign_key: true
      t.references :call, null: true, foreign_key: true
      t.string :sid
      t.string :resource_sid
      t.text :message
      t.string :request_url
      t.string :request_method
      t.string :error_code
      t.datetime :twilio_created_at

      t.timestamps
    end
  end
end
