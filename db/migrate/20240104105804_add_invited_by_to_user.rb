# frozen_string_literal: true

class AddInvitedByToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :created_by, null: true, foreign_key: { to_table: :users }
    add_reference :accounts, :created_by, null: true, foreign_key: { to_table: :users }

    Account.update(created_by_id: User.first.id)
  end
end
