# frozen_string_literal: true

class AddSidToFunctionLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :function_logs, :sid, :string
  end
end
