# frozen_string_literal: true

class AddUniqueIndexToFunctionLogsSid < ActiveRecord::Migration[7.0]
  def change
    add_index :function_logs, :sid, unique: true
  end
end
