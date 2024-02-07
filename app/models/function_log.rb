# frozen_string_literal: true

class FunctionLog < ApplicationRecord
  belongs_to :twilio_account

  validates :sid, uniqueness: true

  scope :search_message, ->(q) { where('message ILIKE ?', "%#{q}%") }
  scope :search_sid, ->(q) { where('sid LIKE ?', "#{q}%") }
  scope :search_level, ->(q) { where('level ILIKE ?', "%#{q}%") }
  scope :search_twilio_account_id, ->(id) { where(twilio_account_id: id) }
  scope :search_account_name, ->(q) { where(twilio_account_id: TwilioAccount.where('name ILIKE ?', "%#{q}%")) }
  scope :search_service_sid, ->(q) { ilike(service_sid: q) }
  scope :search_environment_sid, ->(q) { ilike(environment_sid: q) }
  scope :search_service_name, ->(q) { ilike(service_name: q) }
  scope :search_function_name, ->(q) { ilike(function_name: q) }
  scope :search_function_sid, ->(q) { ilike(function_sid: q) }

  def self.search_any(term)
    scope = joins(:twilio_account)
    scope
      .search_level(term)
      .or(scope.search_message(term))
      .or(scope.search_level(term))
      .or(scope.search_account_name(term))
      .or(scope.search_service_sid(term))
      .or(scope.search_service_name(term))
      .or(scope.search_environment_sid(term))
      .or(scope.search_function_name(term))
  end

  def self.search(terms)
    all.then do |scope|
      scope = scope.search_all(terms.search_all) if terms.search_all.present?
      scope = scope.search_twilio_account_id(terms.twilio_account_id) if terms.twilio_account_id.present?
      scope
    end
  end

  def self.upsert_from_twilio(obj)
    function_log = where(sid: obj.sid, twilio_account_id: obj.twilio_account_id).first_or_initialize

    function_log.update!(
      obj.attributes_for_function_log
    )
  end

  class << self
  
    # Methods to test pulling functions logs from Twilio. 
    def run_all
      TwilioAccount.all.each do |twilio_account|
        fetch_logs(twilio_account)
      end
    end
  
    def fetch_logs(twilio_account)
      puts "Fetching logs for TWILIO ACCOUNT #{twilio_account.name}" if twilio_account.service_environments.any?
      twilio_account.service_environments.each do |service_environment|
        fetch_logs_for_environment(twilio_account, service_environment)
      end
    end

    def fetch_logs_for_environment(twilio_account, service_environment)
      begin
        logs = fetch_logs_from_twilio(twilio_account, service_environment)

        logs.each do |log|
          upsert_function_log(log, twilio_account, service_environment)
        end
      rescue StandardError => e
        abort "Error occurred while fetching logs: #{e.message}"
      end
    end
  
    def fetch_logs_from_twilio(twilio_account, service_environment)
      puts "Making request to Twilio for #{service_environment.service_name}"
      twilio_account.client.serverless.v1
                    .services(service_environment.service_sid)
                    .environments(service_environment.environment_sid)
                    .logs
                    .list(limit: 20)
    end
   
    def upsert_function_log(log, twilio_account, service_environment)
      FunctionLog.upsert_from_twilio(
        TwilioFunctionLog.new(
          twilio_api_log: log,
          twilio_account:,
          service_name: service_environment.service_name,
          environment_name: service_environment.environment_sid,
          function_name: log.function_sid,
          function_sid: log.function_sid
        )
      )
    end
  
  end  

end
