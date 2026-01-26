class JobApplicationPolicy < ApplicationPolicy
  def index?
    user&.admin? || user&.hiring?
  end

  def show?
    user&.admin? || user&.hiring?
  end

  def create?
    true # Allow anyone to create job applications
  end

  def update?
    user&.admin? || user&.hiring?
  end

  def destroy?
    user&.admin?
  end

  def download_pdf?
    user&.admin? || user&.hiring?
  end

  def document?
    user&.admin? || user&.hiring?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.admin? || user&.hiring?
        scope.all
      else
        scope.none
      end
    end
  end
end 