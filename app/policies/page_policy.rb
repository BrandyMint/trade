class PagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    manager? || record.is_active
  end

  def edit?
    manager?
  end

  def update?
    manager?
  end
end
