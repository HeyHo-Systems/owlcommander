# frozen_string_literal: true

class TwilioAccountPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    scope.exists? record.id
  end

  def new?
    user.present?
  end

  def create?
    return false if user.blank?

    user.accounts.exists?(record.account_id) || superuser?
  end

  def update?
    scope.exists? record.id
  end

  def destroy?
    scope.exists? record.id
  end

  private

  def scope
    Scope.new(user, TwilioAccount.all).resolve
  end

  class Scope < Scope
    def resolve
      return scope.none if user.blank?
      return scope.all if superuser?

      scope.where(account: user.accounts)
    end
  end
end
