# frozen_string_literal: true

ConferenceSearch = Struct.new(:search_all, :twilio_account_id, :sort_field, :sort_dir, keyword_init: true) do
  include Sortable

  def terms
    search_all.to_s.strip.split(/\s|:/)
  end

  def default_sort_field
    'twilio_date_created'
  end

  def sortable_fields
    %w[friendly_name status reason_conference_ended twilio_date_created date_updated twilio_accounts.name conference.friendly_name]
  end

  def desc_by_default_fields
    %w[twilio_date_created twilio_date_updated]
  end
end
