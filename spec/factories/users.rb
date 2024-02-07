# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { generate(:email) }
    password { SecureRandom.uuid }

    trait :superuser do
      superuser { true }
    end
  end
end
