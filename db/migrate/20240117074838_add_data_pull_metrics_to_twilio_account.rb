# frozen_string_literal: true

class AddDataPullMetricsToTwilioAccount < ActiveRecord::Migration[7.0]
  def change
    change_table :twilio_accounts, bulk: true do |t|
      t.string :last_pull_status
      t.datetime :last_pull_start
      t.datetime :last_pull_end
    end
    remove_column :twilio_accounts, :last_pull_worked, type: :boolean, default: false, null: false
  end
end
