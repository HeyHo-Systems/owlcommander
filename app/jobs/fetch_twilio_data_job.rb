# frozen_string_literal: true

class FetchTwilioDataJob < ApplicationJob
  queue_as :default

  # fetch_logs disabled for now
  METHODS = %i[fetch_lines fetch_calls fetch_conferences fetch_alerts fetch_conversations].freeze

  def perform # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    TwilioAccount.find_each do |twilio_account|
      last_run_failed = twilio_account.last_pull_status == 'error'
      twilio_account.update(last_pull_status: 'pulling', last_pull_start: Time.zone.now, last_pull_end: nil)
      error = nil
      METHODS.each do |method_name|
        send(method_name, twilio_account)
      rescue StandardError => e
        error = e
        if last_run_failed
          last_rollbar_report = Rails.cache.fetch("last_rollbar_report_#{twilio_account.id}")
          if last_rollbar_report.nil? || Time.zone.now - last_rollbar_report > 1.hour
            Rollbar.error "Pulling #{method_name} for account #{twilio_account.name} failed", { method_name:, twilio_account_id: twilio_account.id }, e
            Rails.cache.write("last_rollbar_report_#{twilio_account.id}", Time.zone.now)
          end
        else
          Rails.logger.warn { "Pulling #{method_name} for account #{twilio_account.name} failed, this happens when twilio is unreachabe. " }
        end
      end
      twilio_account.update(last_pull_status: (error ? 'error' : 'success'), last_pull_end: Time.zone.now)
    end
    # Enqueue the job again
    FetchTwilioDataJob.set(wait: 15.seconds).perform_later
  end

  private

  def fetch_conversations(twilio_account)
    twilio_account.client.conversations.v1.conversations
                  .stream(limit: 200, page_size: 5)
                  .each do |item|
      break if Conversation.upsert_from_twilio(
        item, twilio_account
      ) == :no_change
    end
  end

  def fetch_calls(twilio_account)
    twilio_account.client.calls
                  .stream(limit: 200, page_size: 5)
                  .each do |twilio_api_call|
      Rails.logger.debug { "treating call #{twilio_api_call.sid} for #{twilio_account.name}" }
      break if Call.upsert_from_twilio(
        TwilioCall.new(twilio_account:, twilio_api_call:)
      ) == :no_change
    end
  end

  def fetch_conferences(twilio_account)
    twilio_account.client.conferences
                  .stream(limit: 200, page_size: 5)
                  .each do |twilio_api_conference|
      break if Conference.upsert_from_twilio(
        TwilioConference.new(twilio_account:, twilio_api_conference:)
      ) == :no_change
    end
  end

  def fetch_lines(twilio_account)
    last_synced = Time.zone.now
    twilio_account.client.incoming_phone_numbers.list.each do |twilio_api_number|
      Number.upsert_from_twilio(
        TwilioNumber.new(twilio_account:, twilio_api_number:, last_synced:)
      )
    end

    # Remove numbers leftover from previous sync, that have been released
    TwilioNumber
      .where(twilio_account_id: twilio_account.id)
      .where.not(last_synced:)
      .destroy_all
  end

  def fetch_alerts(twilio_account)
    twilio_account.client.monitor.v1.alerts.list(start_date: start_date(twilio_account)).each do |twilio_api_alert|
      Alert.upsert_from_twilio(
        TwilioAlert.new(twilio_account:, twilio_api_alert:)
      )
    end
  end

  # def fetch_logs(twilio_account)
  #   if twilio_account.service_environments.any?
  #     Rails.logger.info { "Fetching logs for TWILIO ACCOUNT #{twilio_account.name}" }
  #   end
  #   twilio_account.service_environments.each do |service_environment|
  #     fetch_logs_for_environment(twilio_account, service_environment)
  #   end
  # end

  # def fetch_logs_for_environment(twilio_account, service_environment)
  #   logs = fetch_logs_from_twilio(twilio_account, service_environment)

  #   logs.each do |log|
  #     upsert_function_log(log, twilio_account, service_environment)
  #   end
  # end

  # def fetch_logs_from_twilio(twilio_account, service_environment)
  #   Rails.logger.info { "Making request to Twilio for #{service_environment.service_name}" }
  #   twilio_account.client.serverless.v1
  #                 .services(service_environment.service_sid)
  #                 .environments(service_environment.environment_sid)
  #                 .logs
  #                 .list(limit: 20)
  # end

  # def upsert_function_log(log, twilio_account, service_environment)
  #   FunctionLog.upsert_from_twilio(
  #     TwilioFunctionLog.new(
  #       twilio_api_log: log,
  #       twilio_account:,
  #       service_name: service_environment.service_name,
  #       environment_name: service_environment.environment_sid,
  #       function_name: log.function_sid,
  #       function_sid: log.function_sid
  #     )
  #   )
  # end

  def start_date(twilio_account)
    last_alert = twilio_account.alerts.reorder(:id).last
    return 30.minutes.ago if last_alert.blank?

    [last_alert.twilio_created_at, 30.minutes.ago].min
  end
end
