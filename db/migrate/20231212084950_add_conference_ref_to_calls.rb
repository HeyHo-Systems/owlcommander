class AddConferenceRefToCalls < ActiveRecord::Migration[7.0]
  def change
    # not all calls are part of a twilio conference, so the ref is nullable
    add_reference :calls, :conference, null: true, foreign_key: true
  end
end
