# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :load_account

  helper_method :current_account

  def current_account
    accounts = policy_scope(Account)
    return accounts.find(params[:account_id]) if params[:account_id]

    accounts.first
  end

  def load_account
    @account = current_account
  end

  def save_search(search_params)
    return if search_params.empty?

    session[:search] = search_params.slice(*saved_keys)
  end

  def saved_search_params
    (session[:search] || {}).to_h.symbolize_keys.slice(*saved_keys)
  end

  def add_saved(params)
    saved_search_params.each do |k, v|
      params[k] = v if params[k].blank?
    end
    params
  end

  def saved_keys
    %i[twilio_account_id]
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_session_path(resource_or_scope)
  end
end
