class CompanyDocumentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def edit?
    record.company.user_id == user.id
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end
end
