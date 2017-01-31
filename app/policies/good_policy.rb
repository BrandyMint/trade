class GoodPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
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
    company.goods.include? record
  end
end
