# frozen_string_literal: true

class MigrateConversationMessagesToJson < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :messages_list, :json, null: true

    ActiveRecord::Base.connection.execute('
     UPDATE conversations SET messages_list = messages::json
    ')
  end
end
