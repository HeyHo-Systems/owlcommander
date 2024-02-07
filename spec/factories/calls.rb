# frozen_string_literal: true

FactoryBot.define do
  factory :call do
    twilio_account
    status { %w[no-answer failed busy canceled queued ringing in-progress completed].sample }
    duration { rand(100) }
    started_at { duration.seconds.ago }
    ended_at { Time.zone.now }
    from_phone { generate(:phone) }
    to_phone { generate(:phone) }
    sid { random_sid('CA') }
    parent_sid { random_sid('CA') }
    account_sid { random_sid('AC') }
    direction { %w[inbound outbound-api outbound-dial].sample }
    queue_time { [0, 1].sample }
  end
end
