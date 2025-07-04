class QuotePolicy < ApplicationPolicy
  def index?
    user&.admin? || user&.broker?
  end

  def show?
    user&.admin? || user&.broker?
  end

  def new?
    user&.admin? || user&.broker?
  end

  def create?
    true # Allow anyone to create quotes (like the current behavior)
  end

  def edit?
    user&.admin? || user&.broker?
  end

  def update?
    user&.admin? || user&.broker?
  end

  def destroy?
    user&.admin? || user&.broker?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.admin? || user&.broker?
        scope.all
      else
        scope.none
      end
    end
  end
end
