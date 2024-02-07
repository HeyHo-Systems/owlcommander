# frozen_string_literal: true

class AddJsonColumnsToConversations < ActiveRecord::Migration[7.0]
  def change
    Conversation.delete_all
    change_table :conversations, bulk: true do |t|
      t.jsonb :twilio_attributes, null: false
      t.jsonb :messages, null: false
      t.integer :messages_count, null: false
    end
  end
end
