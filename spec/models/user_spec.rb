# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }
  let(:account) { create(:account) }

  describe '#memberships' do
    let!(:membership) { user.memberships.create(account:) }

    before do
      create(:membership)
    end

    it 'returns the memberships of the user' do
      expect(user.memberships).to contain_exactly(membership)
    end
  end

  describe '#accounts' do
    before do
      user.memberships.create(account:)
      create(:account) # unassociated account
    end

    it 'returns all accounts associated through memberships' do
      expect(user.accounts).to contain_exactly(account)
    end
  end

  describe '#destroy' do
    subject(:destroy) { user.destroy }

    before do
      user.memberships.create(account:)
      create(:membership)
    end

    it 'cleans up memberships' do
      expect { destroy }.to change(Membership, :count).from(2).to(1)
    end

    it 'does not delete associated accounts' do
      expect { destroy }.not_to change(Account, :count)
    end
  end
end
