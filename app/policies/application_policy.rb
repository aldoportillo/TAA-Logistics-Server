class ApplicationPolicy < Struct.new(:user, :application)
  def index?
    user.admin? || user.hiring?
  end

  def show?
    user.admin? || user.hiring?
  end

  def destroy?
    user.admin?
  end
end
