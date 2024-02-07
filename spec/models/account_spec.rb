# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account do
  let(:user) { create(:user) }
  let(:account) { create(:account) }

  describe '#name' do
    it 'must be unique' do
      existing = create(:account)
      duplicate = build(:account, name: existing.name)

      duplicate.valid?
      expect(duplicate.errors).to include(:name)
    end
  end

  describe '#memberships' do
    let!(:membership) { account.memberships.create(user:) }

    before do
      create(:membership)
    end

    it 'returns the memberships of the account' do
      expect(account.memberships).to contain_exactly(membership)
    end
  end

  describe '#users' do
    before do
      account.memberships.create(user:)
      create(:user) # unassociated user
    end

    it 'returns all users associated through memberships' do
      expect(account.users).to contain_exactly(user)
    end
  end

  describe '#destroy' do
    subject(:destroy) { account.destroy }

    before do
      account.memberships.create(user:)
      create(:membership)
    end

    it 'cleans up memberships' do
      expect { destroy }.to change(Membership, :count).from(2).to(1)
    end

    it 'does not delete associated users' do
      expect { destroy }.not_to change(User, :count)
    end
  end
end
