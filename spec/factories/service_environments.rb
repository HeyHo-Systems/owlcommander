FactoryBot.define do
  factory :service_environment do
    twilio_account_id { 1 }
    service_sid { "MyString" }
    service_name { "MyString" }
    environment_sid { "MyString" }
  end
end
