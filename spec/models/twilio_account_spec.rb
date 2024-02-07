# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TwilioAccount do
  describe '#api_key_secret' do
    subject(:twilio_account) { create(:twilio_account) }

    it 'is encrypted' do
      expect(twilio_account.encrypted_attribute?(:api_key_secret)).to be true
    end
  end

  describe '#name' do
    it 'must be unique within an account' do
      existing = create(:twilio_account)
      duplicate = build(:twilio_account, name: existing.name, account: existing.account)

      duplicate.valid?
      expect(duplicate.errors).to include(:name)
    end

    it 'can be duplicated between accounts' do
      existing = create(:twilio_account)
      duplicate = build(:twilio_account, name: existing.name)

      expect(duplicate).to be_valid
    end
  end
end
