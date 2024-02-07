# frozen_string_literal: true

NumberSearch = Struct.new(:search_all, :name, :phone, :twilio_account_id, :voice_url, :sort_field, :sort_dir,
                          keyword_init: true) do
  include Sortable

  def terms
    search_all.to_s.strip.split(/\s|:/)
  end

  def default_sort_field
    'name'
  end

  def sortable_fields
    %w[phone name twilio_accounts.name voice_url]
  end

  def desc_by_default_fields
    []
  end
end
