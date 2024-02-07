# frozen_string_literal: true

class CallsController < ApplicationController
  before_action :load_and_save_search

  def index
    searched_items = search_scope.search(@search)
    @total_searched_calls = searched_items.count
    @pagy, @calls = pagy(searched_items.order(@search.order))
    @new_threshold = DateTime.now - 5.seconds
    last_call = nil
    @groupped_calls = []
    @calls.each do |call|
      if last_call && last_call.root_call_created_at == call.root_call_created_at
        call.follower = true
        last_call.followed = true
      end
      last_call = call
    end
  end

  def export
    format = params[:format]
    calls = search_scope.search(@search).order(@search.order)
    pp "export calls #{calls.count}"
    case format
    when "csv"
      csv_data = Call.to_csv(calls)
      send_data csv_data, filename: "calls-#{Time.zone.now.in_time_zone('Europe/Berlin').strftime("%Y-%m-%d-%H-%M-%S")}.csv"
    else
      flash[:error] = "Invalid export format"
      redirect_back(fallback_location: root_path)
    end
  end
  


  private

  def load_and_save_search
    save_search search_params
    @search = CallSearch.new(**add_saved(search_params))
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
      .includes(
        :twilio_account,
        :from_app,
        :to_app,
        :from_number,
        :to_number,
        :alerts
      )
  end

  def scope
    policy_scope(default_scope)
  end

  def default_scope
    return Call.none if @account.blank?

    @account.calls
  end
end
