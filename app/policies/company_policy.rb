class CompanyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    owner? || is_admin? || record.verified?
  end

  def edit?
    owner? && !record.accepted? && !record.being_reviewed?
  end

  def update?
    edit?
  end

  def owner?
    record.user_id == user.try(:id)
  end
end
