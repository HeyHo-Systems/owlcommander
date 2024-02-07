# frozen_string_literal: true

FactoryBot.define do
  factory :conversation do
    sid { random_sid('CH') }
  end
end
