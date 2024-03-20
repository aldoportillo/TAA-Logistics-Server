class InquiryPolicy < ApplicationPolicy
  def index?
    user.broker? || user.hiring? || user.admin?
  end

  def show?
    user.broker? || user.hiring? || user.admin?
  end

  def create?
    true # Optional: Allow anyone to create an inquiry
  end

  def new?
    create?
  end

  def edit?
    user.broker? || user.hiring? || user.admin?
  end

  def update?
    edit?
  end

  def destroy?
    user.admin? # Only admins can delete inquiries
  end
end
