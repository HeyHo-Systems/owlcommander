# frozen_string_literal: true

require 'rails_helper'

RSpec.describe App do
  describe '.upsert_from_twilio' do
    subject(:upsert) { described_class.upsert_from_twilio(twilio_application) }

    let(:twilio_account) { create(:twilio_account) }
    let(:twilio_api_application) { create(:twilio_api_application) }
    let(:twilio_application) { create(:twilio_application, twilio_account:, twilio_api_application:) }

    context 'when there is no existing application' do
      it 'creates a new application' do
        expect { upsert }.to change(described_class, :count).by(1)
      end

      it 'persists the correct attributes' do # rubocop:disable RSpec/ExampleLength
        upsert
        application = described_class.last
        expect(application).to have_attributes(
          sid: twilio_api_application.sid,
          twilio_account_id: twilio_account.id,
          name: twilio_api_application.friendly_name
        )
      end
    end
  end
end
