# frozen_string_literal: true

FunctionLogSearch = Struct.new(:search_all, :twilio_account_id, :sort_field, :sort_dir, :service_name,
                               :function_name, :function_sid, keyword_init: true) do
  include Sortable

  def terms
    search_all.to_s.strip.split(/\s|:/)
  end

  def default_sort_field
    'date_created'
  end

  def sortable_fields
    %w[date_created level message twilio_accounts.name service_sid service_name environment_sid function_name
       function_sid]
  end

  def desc_by_default_fields
    %w[date_created]
  end
end
