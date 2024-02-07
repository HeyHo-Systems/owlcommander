# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    return false if user.blank?

    user.colleagues.exists?(record.id) || superuser?
  end

  def new?
    #  Anyone can create a new user as they are inviting them
    user.present?
  end

  def create?
    # You can't create yourself
    user.present? && user != record
  end

  def edit?
    update?
  end

  def update?
    user == record || superuser?
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      return scope.none if user.blank?
      return scope.all if superuser?

      scope.where(id: user.colleagues.pluck(:id))
    end
  end
end
