# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :phone do |n|
    "+49#{n.to_s.rjust(7, '0')}"
  end
end
