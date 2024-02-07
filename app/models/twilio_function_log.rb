# frozen_string_literal: true

class TwilioFunctionLog
  delegate :id, to: :twilio_account, prefix: true
  delegate :sid,
           :level,
           :message,
           :request_sid,
           :date_created,
           :service_sid,
           :environment_sid,
           :deployment_sid,
           to: :twilio_api_log

  def initialize(twilio_api_log:, twilio_account:, service_name:, environment_name:, function_name:, function_sid:)
    @twilio_account = twilio_account
    @twilio_api_log = twilio_api_log
    @service_name = service_name
    @environment_name = environment_name
    @function_name = function_name
    @function_sid = function_sid
  end

  def attributes_for_function_log
    {
      sid:, twilio_account:,
      service_sid:, service_name:, environment_sid:, environment_name:, function_name:, function_sid:,
      deployment_sid:, request_sid:,
      level:, message:,
      date_created:
    }
  end

  private

  attr_reader :twilio_account, :twilio_api_log, :service_name, :environment_name, :function_name, :function_sid
end
