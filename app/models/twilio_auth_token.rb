# frozen_string_literal: true

# Takes a Twilio account_sid and auth_token and exchanges it for an API key
class TwilioAuthToken
  class TwilioApiKeyCreationFailed < StandardError; end

  API_KEY_NAME = 'Owl Commander'

  class << self
    def exchange_for_api_key(account_sid:, auth_token:)
      client = Twilio::REST::Client.new(account_sid, auth_token)
      random_suffix = SecureRandom.hex(8)

      client.new_keys.create(friendly_name: "#{API_KEY_NAME} #{random_suffix}")
    rescue StandardError => e
      raise TwilioApiKeyCreationFailed, e.message
    end
  end
end
