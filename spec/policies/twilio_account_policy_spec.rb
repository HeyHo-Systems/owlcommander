# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TwilioAccountPolicy, type: :policy do
  subject { described_class.new(user, twilio_account) }

  let(:resolved_scope) do
    described_class::Scope.new(user, TwilioAccount.all).resolve
  end

  let(:account) { create(:account) }
  let(:twilio_account) { create(:twilio_account, account:) }
  let!(:other_twilio_account) { create(:twilio_account) }

  context 'without a user' do
    let(:user) { nil }

    describe '.scope' do
      it 'returns none' do
        expect(resolved_scope).to be_empty
      end
    end

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:new) }
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

      it 'returns only accounts to which they belong' do
        expect(resolved_scope).to contain_exactly(twilio_account)
      end
    end

    context 'with an account they belong to' do
      before do
        create(:membership, user:, account:)
      end

      it { is_expected.to permit_action(:index) }
      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_action(:create) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to permit_action(:destroy) }
    end

    context 'with an account they do not belong to' do
      it { is_expected.to permit_action(:index) }
      it { is_expected.to permit_action(:new) }
      it { is_expected.to forbid_action(:show) }
      it { is_expected.to forbid_action(:create) }
      it { is_expected.to forbid_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end
  end

  context 'with a superuser' do
    let(:user) { create(:user, :superuser) }

    describe '.scope' do
      it 'returns all accounts' do
        expect(resolved_scope).to contain_exactly(twilio_account, other_twilio_account)
      end
    end

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end
end
