# frozen_string_literal: true

class IndexCallsBySid < ActiveRecord::Migration[7.0]
  def change
    add_index :calls, %i[twilio_account_id sid], unique: true
  end
end
