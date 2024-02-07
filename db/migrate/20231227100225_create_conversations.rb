# frozen_string_literal: true

class CreateConversations < ActiveRecord::Migration[7.0]
  def change
    create_table :conversations do |t|
      t.string :account_sid
      t.string :sid
      t.string :friendly_name
      t.string :chat_service_sid
      t.string :messaging_service_sid
      t.string :unique_name
      t.string :state # active, inactive or closed
      t.datetime :date_created
      t.datetime :date_updated
      t.datetime :date_inactive, null: true # timers.date_inactive
      t.datetime :date_closed, null: true # timers.date_closed

      t.references :twilio_account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
