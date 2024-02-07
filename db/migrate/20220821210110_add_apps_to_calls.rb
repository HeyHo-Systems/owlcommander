# frozen_string_literal: true

class AddAppsToCalls < ActiveRecord::Migration[7.0]
  def change
    change_table :calls do |t|
      t.references :from_app, null: true, foreign_key: { to_table: :apps }
      t.references :to_app, null: true, foreign_key: { to_table: :apps }
    end
  end
end
