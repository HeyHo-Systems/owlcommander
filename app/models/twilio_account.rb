# frozen_string_literal: true

class TwilioAccount < ApplicationRecord
  belongs_to :account
  has_many :alerts, dependent: :destroy
  has_many :apps, dependent: :destroy
  has_many :calls, dependent: :destroy
  has_many :numbers, dependent: :destroy
  has_many :conferences, dependent: :destroy
  has_many :function_logs, dependent: :destroy
  has_many :service_environments, dependent: :destroy
  has_many :conversations, dependent: :destroy

  before_destroy :destroy_calls

  encrypts :api_key_secret

  validates :name, presence: true, uniqueness: { scope: %i[account_id] }
  validates :account_sid, presence: true, uniqueness: { scope: %i[account_id region] }
  validates :api_key, presence: { unless: :skip_api_key? }
  validates :api_key_secret, presence: { unless: :skip_api_key? }

  scope :search_name, ->(q) { ilike(name: q).or(where(account_id: Account.search_name(q))) }

  def client
    @client ||= Twilio::REST::Client.new(api_key, api_key_secret, account_sid)
    # This decides what we will see
    @client.region = region
    # Looks like that's the closest to our heorku dyno
    @client.edge = 'dublin'
    @client
  end

  attribute :auth_token, default: ''
  attr_accessor :skip_api_key

  def skip_api_key?
    skip_api_key
  end

  # We need to delete all calls with to_app_id or from_app_id before we can destroy the TwilioAccount
  def destroy_calls
    account.calls.each do |call|
      call.destroy if call.to_app_id == id || call.from_app_id == id || call.twilio_account_id == id
    end
  end

  def color
    palette = ['#ea5545', '#f46a9b', '#ef9b20', '#edbf33', '#ede15b', '#bdcf32', '#87bc45', '#27aeef', '#b33dc6']
    palette[id % palette.count]
  end
end
