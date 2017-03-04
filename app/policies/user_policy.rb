class UserPolicy < ApplicationPolicy
  def edit?
    user == record
  end

  def update?
    edit?
  end

  def admin?
    user.is_admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
