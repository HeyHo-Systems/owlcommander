# frozen_string_literal: true

class AccountPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def show?
    scope.exists?(record.id)
  end

  def destroy?
    scope.exists?(record.id)
  end

  def edit?
    scope.exists?(record.id)
  end

  def update?
    scope.exists?(record.id)
  end

  private

  def scope
    Scope.new(user, Account.all).resolve
  end

  class Scope < Scope
    def resolve
      return scope.none if user.blank?
      return scope.all if superuser?

      scope.where(id: user.accounts)
    end
  end
end
