# frozen_string_literal: true

class AccountsController < AuthenticatedController
  before_action :load_account, except: %i[new create]

  def show
    @title = "Settings of team #{@account.name}"
    @users = policy_scope(@account.users).order(:name)
    @twilio_accounts = policy_scope(@account.twilio_accounts)
                       .order(:name)

    render :show
  end

  def new
    @title = 'Create a new team'
    @account = Account.new
    authorize @account, :create?
  end

  def create
    authorize Account

    @account = Account.new(account_params.merge(created_by_id: current_user.id))
    if @account.save
      Membership.create(user: current_user, account: @account)
      redirect_to account_path(@account), notice: I18n.t('team.created')
    else
      redirect_to new_account_path, alert: I18n.t('team.duplicate_exists')

    end
  end

  def update
    if @account.update(name: account_params[:name])
      redirect_to account_path(@account), notice: I18n.t('team.renamed')
    else
      redirect_to account_path(@account), alert: I18n.t('team.failed_to_rename')
    end
  end

  def destroy
    @account.destroy
    redirect_to root_path, notice: I18n.t('team.detroyed')
  end

  private

  def account_params
    params.require(:account).permit(:name)
  end

  def scope
    policy_scope(Account)
  end

  def load_account
    @account = scope.find(params[:id])
    return unless @account

    authorize @account
    
  end
end
