# frozen_string_literal: true

class MembershipPolicy < ApplicationPolicy
  def show?
    user&.accounts&.exists?(@record.account_id) || superuser?
  end

  def create?
    user&.accounts&.exists?(@record.account_id) || superuser?
  end

  def destroy?
    user&.accounts&.exists?(@record.account_id) || superuser?
  end

  private

  def scope
    Scope.new(user, Membership.all).resolve
  end

  class Scope < Scope
    def resolve
      return scope.none if user.blank?
      return scope.all if superuser?

      scope.where(account: user.accounts)
    end
  end
end
