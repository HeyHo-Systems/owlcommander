# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Number do
  describe '.upsert_from_twilio' do
    subject(:upsert) { described_class.upsert_from_twilio(twilio_number) }

    let(:twilio_account) { create(:twilio_account) }
    let(:twilio_api_number) { create(:twilio_api_number) }
    let(:twilio_number) { create(:twilio_number, twilio_account:, twilio_api_number:) }

    context 'when there is no existing number' do
      it 'creates a new number' do
        expect { upsert }.to change(described_class, :count).by(1)
      end

      it 'persists the correct attributes' do # rubocop:disable RSpec/ExampleLength
        upsert
        number = described_class.last
        expect(number).to have_attributes(
          sid: twilio_api_number.sid,
          twilio_account_id: twilio_account.id,
          phone: twilio_api_number.phone_number,
          name: twilio_api_number.friendly_name,
          address_sid: twilio_api_number.address_sid,
          bundle_sid: twilio_api_number.bundle_sid,
          identity_sid: twilio_api_number.identity_sid,
          status_url: twilio_api_number.status_callback,
          status_method: twilio_api_number.status_callback_method,
          voice_url: twilio_api_number.voice_url,
          voice_method: twilio_api_number.voice_method,
          voice_fallback_url: twilio_api_number.voice_fallback_url,
          voice_fallback_method: twilio_api_number.voice_fallback_method,
          sms_url: twilio_api_number.sms_url,
          sms_method: twilio_api_number.sms_method,
          sms_fallback_url: twilio_api_number.sms_fallback_url,
          sms_fallback_method: twilio_api_number.sms_fallback_method
        )
      end
    end
  end
end
