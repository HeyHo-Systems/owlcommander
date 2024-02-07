# frozen_string_literal: true

CallSearch = Struct.new(:search_all, :twilio_account_id, :sort_field, :sort_dir, keyword_init: true) do
  include Sortable

  def secondary_sort
    # always show the root call of a call group first. Add the id sort to make sure things don't shift around refreshes
    { twilio_date_created: 'asc', id: 'asc' }
  end

  def terms
    search_all.to_s.strip.split(/\s|:/)
  end

  def default_sort_field
    'root_call_created_at'
  end

  def sortable_fields
    %w[root_call_created_at from_phone to_phone duration status twilio_accounts.name parent_sid]
  end

  def desc_by_default_fields
    %w[root_call_created_at]
  end
end
