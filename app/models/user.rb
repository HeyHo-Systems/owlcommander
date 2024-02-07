# frozen_string_literal: true

class User < ApplicationRecord
  has_many :memberships, dependent: :destroy

  has_many :accounts, through: :memberships
  has_many :twilio_accounts, through: :accounts

  has_many :alerts, through: :twilio_accounts
  has_many :calls, through: :twilio_accounts
  has_many :numbers, through: :twilio_accounts
  has_many :function_logs, through: :twilio_accounts
  has_many :conferences, through: :twilio_accounts
  has_many :conversations, through: :twilio_accounts

  has_many :referred_users, class_name: :User, foreign_key: :created_by_id, inverse_of: :creator, dependent: :nullify
  has_many :created_teams, class_name: :Account, foreign_key: :created_by_id, inverse_of: :creator, dependent: :nullify
  belongs_to :creator, class_name: :User, optional: true, foreign_key: :created_by_id,
                       inverse_of: :referred_users

  devise :database_authenticatable,
         :lockable,
         :recoverable,
         :trackable,
         :validatable,
         :registerable,
         :timeoutable

  validates :email, presence: true, uniqueness: true

  def name_or_email
    return email if name.blank?

    name
  end

  def current_sign_in_ip
    nil
  end

  def last_sign_in_ip
    nil
  end

  def current_sign_in_ip=(_)
    # we're not saving this to prevent GDPR shenanigans
  end

  def last_sign_in_ip=(_)
    # we're not saving this to prevent GDPR shenanigans
  end

  def membership_of(account)
    memberships.where(account:).first
  end

  def colleagues
    # if a user has no team, he is stil his own colleague
    return User.where(id:) if memberships.empty?

    User.joins(:memberships).where(memberships: { account_id: account_ids }).distinct
  end
end
