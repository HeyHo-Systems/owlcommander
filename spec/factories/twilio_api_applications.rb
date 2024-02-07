# frozen_string_literal: true

TwilioApiApplication = Struct.new(
  :sid,
  :account_sid,
  :friendly_name,
  :date_created,
  :date_updated
)

FactoryBot.define do
  factory :twilio_api_application do
    sid { random_sid('AP') }
    account_sid { random_sid('AC') }
    friendly_name { 'Random Twilio Application' }
    date_created { Time.zone.today }
    date_updated { Time.zone.today }

    skip_create
  end
end
