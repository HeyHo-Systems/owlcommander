# frozen_string_literal: true

class NumbersController < ApplicationController
  before_action :load_number, except: %i[index]
  before_action :load_and_save_search

  def index
    searched_numbers = search_scope.search(@search)
    @total_numbers_searched = searched_numbers.count
    @pagy, @numbers = pagy(searched_numbers.order(@search.order))
    respond_to do |f|
      f.turbo_stream
      f.html
    end
  end

  def update
    @number.update_and_persist_to_twilio(number_params)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          @number, partial: 'number', locals: { number: @number, search: @search }
        )
      end
      format.html { redirect_to numbers_path }
    end
  end

  private

  def load_and_save_search
    save_search search_params
    @search = NumberSearch.new(**add_saved(search_params))
  end

  def number_params
    params.require(:number).permit(
      :name
    )
  end

  def load_number
    @number = Number.find(params[:id])
    authorize @number
  end

  def search_params
    return {} unless params.key?(:search)

    params.require(:search).permit(
      :search_all,
      :phone,
      :name,
      :twilio_account_id,
      :voice_url,
      :sort_field,
      :sort_dir
    )
  end

  def search_scope
    scope.includes(:twilio_account)
  end

  def scope
    policy_scope(default_scope)
  end

  def default_scope
    return Number.none if current_account.blank?

    current_account.numbers
  end
end
