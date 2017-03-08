class GoodPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def orderable?
    record.is_available?
  end

  def show?
    owner? || orderable?
  end

  def new?
    create?
  end

  def create?
    user.present? && record.company.present? && record.company.accepted?
  end

  def update?
    owner?
  end

  def destroy?
    update?
  end

  def owner?
    user.present? && record.user == user
  end
end
