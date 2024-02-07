# frozen_string_literal: true

class AddNameToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :name, null: true
    end
  end
end
