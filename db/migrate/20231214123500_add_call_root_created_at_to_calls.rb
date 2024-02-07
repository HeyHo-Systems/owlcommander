# frozen_string_literal: true

class AddCallRootCreatedAtToCalls < ActiveRecord::Migration[7.0]
  def change
    add_column :calls, :root_call_created_at, :datetime
    # Just back-fill with its own start as actually looking for the root calls in a performant way would be complicated
    # rubocop:disable Rails::SkipsModelValidations
    Call.update_all('root_call_created_at = twilio_date_created')
    # rubocop:enable Rails::SkipsModelValidations
  end
end
