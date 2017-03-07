class UserTransactionsController < ApplicationController
  before_action :require_login

  layout 'profile'

  def index
    render locals: {
      counts: {
        total: all_transactions.count,
        income: income_transactions.count,
        outcome: outcome_transactions.count
      },
      transactions: transactions,
      type: type,
      companies: current_user.companies.order('id desc')
    }
  end

  def show
    transaction = OpenbillTransaction.find params[:id]
    authorize transaction

    render locals: { transaction: transaction }
  end

  private

  def type
    params[:type]
  end

  def transactions
    if type == 'income'
      scope = income_transactions
    elsif type == 'outcome'
      scope = outcome_transactions
    else
      scope = all_transactions
    end
    scope.order('id desc').page params[:page]
  end

  def all_transactions
    current_user.transactions
  end

  def income_transactions
    all_transactions.where(to_account_id: current_user.account_ids)
  end

  def outcome_transactions
    all_transactions.where(from_account_id: current_user.account_ids)
  end
end
