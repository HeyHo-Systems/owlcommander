# frozen_string_literal: true

class AddLastPullWorkedToTwilioAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :twilio_accounts, :last_pull_worked, :boolean, default: false, null: false
  end
end
