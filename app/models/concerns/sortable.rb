# frozen_string_literal: true

module Sortable
  # requires the including class to define:
  #   #default_sort_field
  #   #sortable_fields
  #   #desc_by_default_fields
  def order
    { sanitized_sort_field => sanitized_sort_dir }.merge secondary_sort
  end

  def secondary_sort
    { id: sanitized_sort_dir }
  end

  def sanitized_sort_field
    return sort_field if sortable_fields.include?(sort_field)

    default_sort_field
  end

  def sanitized_sort_dir
    return sort_dir if %w[asc desc].include?(sort_dir)

    default_order_for(sanitized_sort_field)
  end

  def default_or_inverse_order_for(sort_field)
    # no need to explicitly add a sort order if we're using the default sort order
    return nil if sort_field != sanitized_sort_field
    return 'asc' if sanitized_sort_dir == 'desc'

    'desc'
  end

  def default_order_for(sort_field)
    return 'desc' if desc_by_default_fields.include?(sort_field)

    'asc'
  end
end
