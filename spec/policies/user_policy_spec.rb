# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class.new(user, user_object) }

  let(:resolved_scope) do
    described_class::Scope.new(user, User.all).resolve
  end

  let(:user_object) { create(:user) }

  context 'without a user' do
    let(:user) { nil }

    describe '.scope' do
      it 'returns none' do
        expect(resolved_scope).to be_empty
      end
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'with a normal user' do
    let(:user) { create(:user) }

    describe '.scope' do
      it 'returns only the current user' do
        expect(resolved_scope).to contain_exactly(user)
      end
    end

    context 'with another user' do
      it { is_expected.to forbid_action(:show) }
      it { is_expected.to permit_action(:create) }
      it { is_expected.to forbid_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end

    context 'with their own user' do
      let(:user_object) { user }

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_action(:create) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to permit_action(:destroy) }
    end
  end

  context 'with a colleague' do
    let(:user) { create(:user) }

    before do
      # Make user and user_object colleagues
      account = create(:account)
      create(:membership, account:, user:)
      create(:membership, account:, user: user_object)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'with a superuser' do
    let(:user) { create(:user, :superuser) }

    describe '.scope' do
      it 'returns all users' do
        expect(resolved_scope).to contain_exactly(user, user_object)
      end
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end
end
