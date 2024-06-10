# frozen_string_literal: true

class AddStatusToNumbers < ActiveRecord::Migration[7.1]
  def change
    add_column :numbers, :status, :string, default: nil
  end
end
