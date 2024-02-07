# frozen_string_literal: true

ConversationSearch = Struct.new(:search_all, :twilio_account_id, :sort_field, :sort_dir, :selected, keyword_init: true) do
  include Sortable

  def secondary_sort
    # always show the root call of a call group first. Add the id sort to make sure things don't shift around refreshes
    { date_created: 'asc', id: 'asc' }
  end

  def terms
    search_all.to_s.strip.split(/\s|:/)
  end

  def default_sort_field
    'date_created'
  end

  def sortable_fields
    %w[date_created date_updated date_inactive date_closed friendly_name unique_name state twilio_accounts.name messages_count]
  end

  def desc_by_default_fields
    %w[date_created]
  end
end
