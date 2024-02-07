# frozen_string_literal: true

class CreateCalls < ActiveRecord::Migration[7.0]
  def change
    create_table :calls do |t|
      t.references :twilio_account, null: false, foreign_key: true
      t.references :from_number, null: true, foreign_key: { to_table: :numbers }
      t.references :to_number, null: true, foreign_key: { to_table: :numbers }
      t.string :from_phone
      t.string :to_phone
      t.string :status
      t.string :direction
      t.integer :duration
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :queue_time
      t.string :sid
      t.string :parent_sid
      t.string :account_sid

      t.timestamps
    end

    add_index :calls, :duration
    add_index :calls, 'from_phone gin_trgm_ops', using: :gin
    add_index :calls, 'to_phone gin_trgm_ops',   using: :gin
  end
end
