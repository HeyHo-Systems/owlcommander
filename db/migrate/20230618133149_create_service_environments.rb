class CreateServiceEnvironments < ActiveRecord::Migration[7.0]
  def change
    create_table :service_environments do |t|
      t.integer :twilio_account_id, null: false
      t.string :service_sid, null: false
      t.string :service_name, null: false
      t.string :environment_sid, null: false

      t.timestamps
    end
  end
end
