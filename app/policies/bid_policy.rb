class BidPolicy < ApplicationPolicy
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
    user&.admin? || user&.broker?
  end

  def edit?
    user&.admin? || user&.broker?
  end

  def update?
    user&.admin? || user&.broker?
  end

  def destroy?
    user&.admin?
  end

  def upload_csv?
    user&.admin? || user&.broker?
  end

  def download_processed?
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