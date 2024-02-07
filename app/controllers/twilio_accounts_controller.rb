# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class TwilioAccountsController < ApplicationController
  before_action :load_account, except: %i[destroy]
  before_action :load_twilio_account, except: %i[new create]

  def new
    @title = @account.name
    @subtitle = I18n.t('team.twilio_accounts.import_title')
    @twilio_account = @account.twilio_accounts.new
    authorize @twilio_account
  end

  def edit
    @title = @twilio_account.name
  end

  def create
    account_sid = import_params[:account_sid]
    auth_token = import_params[:auth_token]
    region = import_params[:region]
    account_id = @account.id

    if TwilioAccount.exists?(account_sid:, account_id:, region:)
      redirect_to @account, notice: I18n.t('team.twilio_accounts.skipped_import')
      return
    end
    name = fetch_account_name(account_sid, auth_token, region)
    key = create_key(account_sid, auth_token, name, region)
    @twilio_account = TwilioAccount.create!(account_id:, name: "#{name} - #{region}", account_sid:, api_key: key['sid'], api_key_secret: key['secret'], region:)

    redirect_to @account, notice: I18n.t('team.twilio_accounts.imported')
  rescue StandardError => e
    redirect_to new_account_twilio_account_path(@account), alert: e.message
  end

  def update
    Rails.logger.debug twilio_account_params[:name]
    if @twilio_account.update(name: twilio_account_params[:name])
      redirect_to @account, notice: I18n.t('team.twilio_accounts.renamed')
    else
      redirect_to @account, alert: I18n.t('team.twilio_accounts.rename_failed')
    end
  end

  def destroy
    @account = @twilio_account.account
    @twilio_account.destroy
    redirect_to @account, notice: I18n.t('team.twilio_accounts.disconnected')
  end

  private

  def fetch_account_name(account_sid, auth_token, region)
    @client = Twilio::REST::Client.new(account_sid, auth_token)
    # This decides what we will see
    @client.region = region
    # Looks like that's the closest to our heorku dyno
    @client.edge = 'dublin'
    @client.api.v2010.accounts(account_sid).fetch.friendly_name
  end

  def create_key(account_sid, auth_token, name, region)
    # Somehow the client.new_keys.create method of the twilio rest api doesn't exist, we have to post json directly
    friendly_name = "Owl commander / #{@account.name} (#{@account.id}) / #{name} (#{(TwilioAccount.last&.id || 0) + 1})"
    uri = URI.parse("https://api.dublin.#{region}.twilio.com/2010-04-01/Accounts/#{account_sid}/Keys.json")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(account_sid, auth_token)
    request.set_form_data({ 'FriendlyName' => friendly_name })
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    key = JSON.parse(response.body)
    raise(StandardError, key['message']) unless key['sid'] && key['secret']

    key
  end

  def account_import_params
    import_params.to_h.symbolize_keys.merge(account: @account)
  end

  def import_params
    params
      .require(:twilio_account)
      .permit(:account_sid, :auth_token, :region)
  end

  def twilio_account_params
    params
      .require(:twilio_account)
      .permit(:name)
  end

  def load_twilio_account
    @twilio_account = TwilioAccount.find(params[:id])
    authorize @twilio_account
  end

  def load_account
    @account = Account.find(params[:account_id])
    authorize @account, :show?
  end
end
