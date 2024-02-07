# frozen_string_literal: true

class AlertsController < ApplicationController
  before_action :load_and_save_search

  def index
    searched_items = search_scope.search(@search)
    @total_searched_alerts = searched_items.count
    @pagy, @alerts = pagy(searched_items.order(@search.order))
    respond_to do |f|
      f.turbo_stream
      f.html
    end
  end

  private

  def load_and_save_search
    save_search search_params
    @search = AlertSearch.new(**add_saved(search_params))
  end

  def search_params
    return {} unless params.key?(:search)

    params.require(:search).permit(
      :search_all,
      :twilio_account_id,
      :sort_field,
      :sort_dir
    )
  end

  def search_scope
    scope
      .includes(:twilio_account, :call)
  end

  def scope
    policy_scope(default_scope)
  end

  def default_scope
    return Alert.none if current_account.blank?

    current_account.alerts
  end
end
