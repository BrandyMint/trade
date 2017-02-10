class Admin::TransactionsController < Admin::ApplicationController
  def show
    @transaction = OpenbillTransaction.find params[:id]
    respond_with @transaction
  end
end
