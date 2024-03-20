class QuotePolicy < Struct.new(:user, :quote)
  def index?
    user.admin? || user.broker?
  end

  def show?
    user.admin? || user.broker?
  end

  def destroy?
    user.admin?
  end
end
