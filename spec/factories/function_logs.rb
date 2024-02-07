# frozen_string_literal: true

FactoryBot.define do
  factory :function_log do
    twilio_account
    service_sid { random_sid('ZS') }
    environment_sid { random_sid('ZE') }
    deployment_sid { random_sid('ZD') }
    function_sid { random_sid('ZF') }
    request_sid { random_sid('RQ') }
    level { 'INFO' }
    message { 'This is a function log' }
    date_created { Time.zone.now }
    sid { random_sid('FL') }
    service_name { 'Service' }
    environment_name { 'Environment' }
    function_name { 'Function' }
  end
end
