# frozen_string_literal: true

AlertSearch = Struct.new(:search_all, :twilio_account_id, :sort_field, :sort_dir, keyword_init: true) do
  include Sortable

  def terms
    search_all.to_s.strip.split(/\s|:/)
  end

  def default_sort_field
    'twilio_created_at'
  end

  def sortable_fields
    %w[twilio_created_at message request_url error_code twilio_accounts.name]
  end

  def desc_by_default_fields
    %w[twilio_created_at]
  end
end
