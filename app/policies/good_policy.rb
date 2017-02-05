class GoodPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    true
    # record.company.accepted?
  end

  def new?
    create?
  end

  def create?
    binding.pry.
    user.present? && record.company.present? && record.company.accepted?
  end

  def update?
    user.present? && user.goods.include?(record)
  end

  def destroy?
    update?
  end
end
