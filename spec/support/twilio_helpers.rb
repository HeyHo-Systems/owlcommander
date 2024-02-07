# frozen_string_literal: true

module TwilioHelpers
  def random_sid(prefix)
    [prefix, 'test', SecureRandom.hex(8)].join('_')
  end

  def random_callback_url(type)
    "https://example/webhook/#{type}"
  end
end
