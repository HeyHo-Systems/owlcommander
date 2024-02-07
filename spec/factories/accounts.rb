# frozen_string_literal: true

# rubocop:disable FactoryBot/FactoryAssociationWithStrategy

AccountWithUser = Struct.new(:account, :user) do
  delegate :twilio_accounts, to: :account
end

FactoryBot.define do
  factory :account do
    sequence(:name) { |n| "Account #{n}" }
  end

  factory :account_with_user do
    account
    user { create(:user) }

    skip_create
    after :create do |obj|
      obj.account.memberships.create(user: obj.user)
    end

    trait :twilio_account do
      after :create do |obj|
        obj.account.twilio_accounts.create(build(:twilio_account, account: obj.account).attributes)
      end
    end

    trait :superuser do
      user { create(:user, :superuser) }
    end
  end
end
# rubocop:enable FactoryBot/FactoryAssociationWithStrategy
