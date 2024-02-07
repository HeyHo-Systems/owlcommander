# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembershipPolicy, type: :policy do
  subject { described_class.new(user, membership) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Membership.all).resolve
  end

  let(:account) { create(:account) }

  context 'without a user, looking at a random membership' do
    let(:user) { nil }
    let(:membership) { create(:membership, account: create(:account), user: create(:user)) }

    before do
      membership
      create(:membership, account:, user: create(:user))
      create(:membership, account: create(:account), user: create(:user))
    end

    it 'has access to 3 memberships total' do
      expect(Membership.all.size).to eq 3
    end

    describe '.scope' do
      it 'returns none' do
        expect(resolved_scope.size).to eq 0
      end
    end

    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'with a user that\'s in a team' do
    let(:user) { create(:user) }
    let(:membership) { create(:membership, account:, user:) }

    before do
      membership
      create(:membership, account:, user: create(:user))
      create(:membership, account: create(:account), user: create(:user))
    end

    it 'has access to 3 memberships total' do
      expect(Membership.all.size).to eq 3
    end

    describe '.scope' do
      it 'returns only the memberships of their teams' do
        expect(resolved_scope.size).to eq 2
      end
    end

    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'with a superuser' do
    let(:user) { create(:user, :superuser) }
    let(:membership) { create(:membership, account:, user:) }

    before do
      membership
      create(:membership, account:, user: create(:user))
      create(:membership, account: create(:account), user: create(:user))
    end

    it 'has access to 3 memberships total' do
      expect(Membership.all.size).to eq 3
    end

    describe '.scope' do
      it 'returns all memberships' do
        expect(resolved_scope.size).to eq 3
      end
    end

    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:destroy) }
  end
end
