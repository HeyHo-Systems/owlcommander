# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class FeedbackController < ApplicationController
  # def new; end

  def create
    text = "#{current_user.name} <#{current_user.email}> left some feeback : \n\n#{params.require(:feedback)}"

    uri = URI.parse(ENV.fetch('SLACK_FEEDBACK_URL', nil))
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = JSON.generate(
      text:
    )
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    Rails.logger.debug response.body.inspect
    redirect_to root_path, notice: I18n.t('feeback.thanks')
  end
end
