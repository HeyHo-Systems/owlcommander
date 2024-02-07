# frozen_string_literal: true

class AddIndexOnTwilioAccountIdAndSidToNumbers < ActiveRecord::Migration[7.0]
  def change
    add_index :numbers, %i[twilio_account_id sid], unique: true
    remove_index :numbers, :twilio_account_id
  end
end
