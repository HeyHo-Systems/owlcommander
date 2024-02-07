# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    superuser?
  end

  def show?
    superuser?
  end

  def create?
    superuser?
  end

  def new?
    superuser?
  end

  def update?
    superuser?
  end

  def edit?
    update?
  end

  def destroy?
    superuser?
  end

  delegate :superuser?, to: :user, allow_nil: true

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    delegate :superuser?, to: :user, allow_nil: true

    attr_reader :user, :scope
  end
end
