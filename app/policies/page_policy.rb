class PagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    is_admin? || record.is_active
  end

  def edit?
    is_admin?
  end

  def update?
    is_admin?
  end
end
