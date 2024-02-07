# frozen_string_literal: true

class MembershipsController < ApplicationController
  before_action :load_membership

  def destroy
    user = @membership.user
    team = @membership.account
    @membership.destroy

    if user.id == current_user.id
      notice = "You have left the team #{team.name}"
      headhome = true
    else
      notice = "User #{user.name_or_email} was removed from the team #{team.name}."
      headhome = false
    end
    if team.reload.memberships.empty?
      team.destroy
      notice = "The team #{team.name} has been destroyed as the last member (#{user.name_or_email}) left. "
      headhome = true
    end

    redirect_to headhome ? root_path : account_path(@account), notice:, status: :see_other
  end

  private

  def scope
    policy_scope(Membership)
  end

  def load_membership
    @membership = scope.find(params[:id])
    authorize @membership
  end
end
