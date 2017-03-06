class UserTransactionsController < ApplicationController
  before_action :require_login

  layout 'profile'

  def index
    render locals: {
      transactions: transactions_index,
      companies: current_user.companies.order('id desc')
    }
  end

  def show
    transaction = OpenbillTransaction.find params[:id]
    authorize transaction

    render locals: { transaction: transaction }
  end

  private

  def transactions_index
    current_user.transactions.order('id desc').page params[:page]
  end
end
