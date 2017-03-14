class Admin::TransactionsController < Admin::ApplicationController

  def show
    @transaction = OpenbillTransaction.find params[:id]
    respond_with @transaction
  end

  def index
    render locals: { transactions: transactions }
  end

  private

  def transactions
    OpenbillTransaction.order('created_at desc').page(params[:page])
  end
end
