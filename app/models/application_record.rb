# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.ilike(**terms)
    terms.map { |field, value| where(normalize_field(field).matches("%#{value}%")) }.reduce(:and)
  end

  def self.ilike_prefix(**terms)
    terms.map { |field, value| where(normalize_field(field).matches("#{value}%")) }.reduce(:and)
  end

  def self.search_all(str)
    # Splits str on spaces then searches for each term, requiring all of them to match
    # Requires the model to define search_any
    str.split.map { |term| search_any(term) }.reduce(:and)
  end

  def self.normalize_field(field)
    return field if field.is_a?(Arel::Attributes::Attribute)

    arel_table[field.to_sym]
  end
end
