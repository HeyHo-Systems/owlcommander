# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name

      t.timestamps
    end
    add_index :accounts, :name, unique: true
  end
end
