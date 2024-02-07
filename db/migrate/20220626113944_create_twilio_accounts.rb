# frozen_string_literal: true

class CreateTwilioAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :twilio_accounts do |t|
      t.string :name
      t.string :account_sid
      t.string :api_key
      t.string :api_key_secret

      t.timestamps
    end
  end
end
