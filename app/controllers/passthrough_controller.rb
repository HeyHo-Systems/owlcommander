# frozen_string_literal: true

class PassthroughController < ApplicationController
  # This only takes care of redirecting visits of / to the main team of the user
  def index
    if policy_scope(Account).empty?
      redirect_to new_account_path
      return
    end
    @account ||= policy_scope(Account).first
    if @account.twilio_accounts.present?
      redirect_to account_calls_path(@account)
    else
      redirect_to account_path(@account)
    end
  end
end
