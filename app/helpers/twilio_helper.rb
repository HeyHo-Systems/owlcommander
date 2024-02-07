# frozen_string_literal: true

module TwilioHelper
  TWIML_BIN = 'https://handler.twilio.com/twiml'
  SIP = /^sip:/
  NGROK = 'ngrok.io/'
  FUNCTION = '.twil.io/'

  def twilio_phone_number_url(number)
    "https://www.twilio.com/console/phone-numbers/incoming/#{number.sid}?x-target-region=#{number.twilio_account.region}"
  end

  def twilio_call_url(call)
    "https://www.twilio.com/console/voice/calls/logs/#{call.sid}?x-target-region=#{call.twilio_account.region}"
  end

  def twilio_conference_url(conference)
    "https://www.twilio.com/console/voice/conferences/logs/#{conference.sid}?x-target-region=#{conference.twilio_account.region}"
  end

  def twilio_conversation_url(conversation)
    "https://www.twilio.com/console/conversations/services/#{conversation.chat_service_sid}/conversations/#{conversation.sid}?x-target-region=#{conversation.twilio_account.region}"
  end

  def twilio_alert_url(alert)
    "https://www.twilio.com/console/runtime/debugger/#{alert.sid}?x-target-region=#{alert.twilio_account.region}"
  end

  def twilio_error_code_url(code)
    "https://www.twilio.com/docs/api/errors/#{code}"
  end

  def twilio_function_url(service_sid, environment_sid, function_sid)
    "https://console.twilio.com/us1/develop/functions/editor/#{service_sid}/environment/#{environment_sid}/function/#{function_sid}"
  end

  def clean_twilio_url(url)
    url
      .gsub(TWIML_BIN, '')
      .gsub(SIP, '')
  end

  def highlight_sid(sid, search)
    # shows a cropped SID, but highlight it if that sid is part of the search
    cropped = sid[0,7]+'...'+sid[-7,7]
    if search.include?(sid)
      return highlight(cropped, [cropped])
    end
    highlight(cropped, search)
  end

  def twilio_url_type(url)
    return 'TwiML Bin' if url.start_with?(TWIML_BIN)
    return 'SIP' if url.match?(SIP)
    return 'Ngrok' if url.match?(NGROK)
    'Function' if url.match?(FUNCTION)
  end

  def twilio_url_color(url)
    return 'bg-purple-200 text-purple-600' if url.start_with?(TWIML_BIN)
    return 'bg-yellow-200 text-yellow-600' if url.match?(NGROK)
    return 'bg-green-200 text-green-600' if url.match?(SIP)
    'bg-sky-200 text-sky-600' if url.match?(FUNCTION)
  end
end
