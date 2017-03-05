class OpenbillTransactionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    user.accounts.include?(record.to_account) ||
      user.accounts.include?(record.from_account)
  end
end
