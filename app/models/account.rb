# frozen_string_literal: true

class Account < ApplicationRecord
  # We call accounts "Teams" in the UI

  has_many :memberships, dependent: :destroy
  has_many :twilio_accounts, dependent: :destroy
  has_many :users, through: :memberships

  has_many :alerts, through: :twilio_accounts
  has_many :calls, through: :twilio_accounts
  has_many :numbers, through: :twilio_accounts
  has_many :function_logs, through: :twilio_accounts
  has_many :conferences, through: :twilio_accounts
  has_many :conversations, through: :twilio_accounts

  validates :name, presence: true, uniqueness: true

  belongs_to :creator,
             class_name: :User,
             optional: true,
             foreign_key: :created_by_id,
             inverse_of: :created_teams

  scope :search_name, ->(q) { ilike(name: q) }
end
