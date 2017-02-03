class CompanyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def edit?
    record.user_id == user.id && !record.accepted?
  end

  def update?
    edit?
  end
end
