class GoodPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def new?
    create?
  end

  def create?
    user.present? && company.present? && company.accepted?
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  private

  delegate :company, to: :user

  def owner?
    user.present? && company.goods.include?(record)
  end
end
