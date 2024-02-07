# frozen_string_literal: true

class AddServiceNameAndEnvironmentNameToFunctionLogs < ActiveRecord::Migration[7.0]
  def change
    change_table :function_logs, bulk: true do |t|
      t.string :service_name
      t.string :environment_name
    end
  end
end
