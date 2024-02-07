# frozen_string_literal: true

class AddRegionToTwilioAccount < ActiveRecord::Migration[7.0]
  def change
    # Add a field to hold the au1, us1 or ie1 value
    add_column :twilio_accounts, :region, :string, default: 'us1'

    # set the unique constrain here
    add_index :twilio_accounts, %i[account_id account_sid region], unique: true
  end
end
