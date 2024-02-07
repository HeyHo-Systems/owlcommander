# frozen_string_literal: true

class AddDefaultAndNotNullToSuperuserInUsers < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :superuser, :boolean, default: false, null: false
  end

  def down
    change_column :users, :superuser, :boolean, default: false, null: true
  end
end
