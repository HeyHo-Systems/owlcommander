# frozen_string_literal: true

class AddFunctionNameToFunctionLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :function_logs, :function_name, :string
  end
end
