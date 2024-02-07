# frozen_string_literal: true

class FunctionLogsController < ApplicationController
  before_action :load_and_save_search

  def index
    searched_items = search_scope.search(@search)
    @total_searched_logs = searched_items.count
    @pagy, @function_logs = pagy(searched_items.order(@search.order))
    respond_to do |f|
      f.turbo_stream
      f.html
    end
  end

  private

  def load_and_save_search
    save_search search_params
    @search = FunctionLogSearch.new(**add_saved(search_params))
  end

  def search_params
    return {} unless params.key?(:search)

    params.require(:search).permit(
      :search_all, :twilio_account_id,
      :sort_field, :sort_dir,
      :service_sid, :environment_sid,
      :service_name, :environment_name,
      :function_name, :function_sid
    )
  end

  def search_scope
    scope
      .includes(:twilio_account)
  end

  def scope
    policy_scope(default_scope)
  end

  def default_scope
    return FunctionLog.none if current_account.blank?

    current_account.function_logs
  end
end
