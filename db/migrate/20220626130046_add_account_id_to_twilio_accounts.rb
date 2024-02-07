# frozen_string_literal: true

class AddAccountIdToTwilioAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :twilio_accounts, :account_id, :integer
    add_index :twilio_accounts, %i[account_id name], unique: true
  end
end
