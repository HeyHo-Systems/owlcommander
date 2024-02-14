# frozen_string_literal: true

class UsersController < AuthenticatedController
  before_action :load_user, except: %i[new create]

  def new
    @title = I18n.t('team.members.add_user_title')
    @user = User.new
    authorize @user
    render :new
  end

  def create
    create_user
    if @user.blank?
      skip_authorization
      redirect_to new_account_user_path(@account), alert: "Could not find user with email #{user_params[:email]}"
      return
    end
    create_membership
    if @user.save && @membership.save
      @user.send_reset_password_instructions unless @existing_user
      redirect_to account_path(@account), notice: @notice
    else
      render :new
    end
  end 

  def update 
    if @user.name == user_params[:name] && @user.email == user_params[:email]
      redirect_to edit_user_path(@user), notice: I18n.t('user.no_change')
      return
    end
    if @user.update(name: user_params[:name], email: user_params[:email])
      redirect_to edit_user_path(@user), notice: I18n.t('user.updated')
    else
      redirect_to edit_user_path(@user), alert: I18n.t('user.update_failed')
    end 
  end

  def destroy 
    @user.accounts.each do |account| 
      account.destroy! if account.users.size == 1 && policy(account).destroy?
    end
    @user.destroy!    
    redirect_to root_path, notice: I18n.t('user.destroyed')
  end

  private

  def create_user
    @existing_user = User.where(email: user_params[:email]).first
    if @existing_user
      @user = @existing_user
      authorize @user, :show?
      @notice = I18n.t('team.members.existing_user_added', user: @user.name_or_email, team: @account.name)
    elsif ENV['SENDGRID_API_KEY'].present?
      @user = User.new(user_params.merge(password: SecureRandom.hex(16), created_by_id: current_user.id))
      authorize @user, :create?
      @notice = I18n.t('team.members.created_user_added', user: @user.name_or_email, team: @account.name)
    end 
  end

  def create_membership
    @existing_membership = @user.membership_of(@account)
    if @existing_membership
      @membership = @existing_membership
      authorize @membership, :show?
      @notice = I18n.t('team.members.already_a_member', user: @user.name_or_email, team: @account.name)
    else
      @membership = @account.memberships.build(user: @user)
      authorize @membership, :create?
    end
  end

  def user_params
    params.require(:user).permit(:email, :name)
  end

  def scope  
    policy_scope(User.all)
  end
 

  def load_user
    @user = scope.find(params[:id])
    authorize @user
  end
end
