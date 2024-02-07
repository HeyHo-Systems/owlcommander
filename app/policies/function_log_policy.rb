# frozen_string_literal: true

class FunctionLogPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    scope.exists?(record.id) || super
  end

  def update?
    superuser?
  end

  def destroy?
    superuser?
  end

  private

  def scope
    Scope.new(user, FunctionLog.all).resolve
  end

  class Scope < Scope
    def resolve
      return scope.none if user.blank?
      return scope.all if superuser?

      scope.where(twilio_account_id: twilio_accounts)
    end

    private

    def twilio_accounts
      TwilioAccountPolicy::Scope.new(user, TwilioAccount.all).resolve
    end
  end
end
