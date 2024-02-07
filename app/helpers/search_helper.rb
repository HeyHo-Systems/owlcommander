# frozen_string_literal: true

module SearchHelper
  def sortable_header(field, label:, search:)
    sort_dir = search.default_or_inverse_order_for(field.to_s)
    search_params = {
      sort_field: field,
      search_all: search.search_all,
      twilio_account_id: search.twilio_account_id
    }
    search_params.merge!(sort_dir:) if sort_dir.present?
    active = field.to_s == search.sanitized_sort_field
    css = "sort-label sort-#{search.sanitized_sort_dir} #{'sort-active' if active}"

    link_to label, url_for(search: search_params), class: css
  end
end
