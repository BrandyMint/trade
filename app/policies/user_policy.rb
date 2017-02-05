class UserPolicy < ApplicationPolicy

  def edit?
    user == record
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
