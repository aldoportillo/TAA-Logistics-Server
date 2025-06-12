class PortPolicy < ApplicationPolicy
  def index?
    user.admin? || user.broker?
  end

  def show?
    user.admin? || user.broker?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end 