# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :load_and_save_search

  def index
    searched_items = search_scope.search(@search)
    @total = searched_items.count
    @pagy, @conversations = pagy(searched_items.order(@search.order))

    @selected = (@search_params[:selected] && @conversations.where(id: @search_params[:selected].to_i).first) || @conversations.first

    respond_to do |f|
      f.turbo_stream
      f.html
    end
  end

  private

  def load_and_save_search
    save_search search_params
    @search_params = search_params
    @search = ConversationSearch.new(**add_saved(search_params))
  end

  def search_params
    return {} unless params.key?(:search)

    params.require(:search).permit(
      :search_all,
      :twilio_account_id,
      :sort_field,
      :sort_dir,
      :selected
    )
  end

  def search_scope
    scope
      .includes(
        :twilio_account
      )
  end

  def scope
    policy_scope(default_scope)
  end

  def default_scope
    return Conversation.none if current_account.blank?

    current_account.conversations
  end
end
