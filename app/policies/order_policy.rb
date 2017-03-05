class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def new?
    user.present? && record.good.published?
  end

  def create?
    new? && record.good.company.user != user
  end
end
