# frozen_string_literal: true

class CreateFunctionLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :function_logs do |t|
      t.references :twilio_account, null: false, foreign_key: true
      t.string :service_sid
      t.string :environment_sid
      t.string :deployment_sid
      t.string :function_sid
      t.string :request_sid
      t.string :level
      t.text :message
      t.datetime :date_created

      t.timestamps
    end
  end
end
