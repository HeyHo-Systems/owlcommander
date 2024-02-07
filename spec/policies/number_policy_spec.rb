# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NumberPolicy, type: :policy do
  subject { described_class.new(user, number) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Number.all).resolve
  end

  let(:account) { create(:account) }
  let(:number) { create(:number, twilio_account: create(:twilio_account, account:)) }
  let!(:other_number) { create(:number) }

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
      before do
        create(:membership, user:, account:)
      end

      it 'returns only numbers of accounts to which they belong' do
        expect(resolved_scope).to contain_exactly(number)
      end
    end

    context 'with a number of an account they belong to' do
      before do
        create(:membership, user:, account:)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_action(:create) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end

    context 'with a number of an account they do not belong to' do
      it { is_expected.to forbid_action(:show) }
      it { is_expected.to forbid_action(:create) }
      it { is_expected.to forbid_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end
  end

  context 'with a superuser' do
    let(:user) { create(:user, :superuser) }

    describe '.scope' do
      it 'returns all numbers' do
        expect(resolved_scope).to contain_exactly(number, other_number)
      end
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end
end
