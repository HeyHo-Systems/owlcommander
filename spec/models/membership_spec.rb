# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Membership do
  describe '#account' do
    subject(:membership) { build(:membership, account: nil) }

    it 'is required' do
      membership.valid?
      expect(membership.errors[:account]).to include('must exist')
    end
  end

  describe '#user' do
    subject(:membership) { build(:membership, user: nil) }

    it 'is required' do
      membership.valid?
      expect(membership.errors[:user]).to include('must exist')
    end
  end
end
