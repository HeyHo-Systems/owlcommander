# frozen_string_literal: true

class DenormalizeMessagesContentForSearch < ActiveRecord::Migration[7.0]
  def change
    Conversation.delete_all
    add_column :conversations, :messages_content, :string
  end
end
