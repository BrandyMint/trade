class Admin::CompanyTransactionsController < Admin::ApplicationController
  respond_to :html

  def new
    render locals: {
      transaction: form,
      company: company
    }
  end

  def index
    render locals: {
      company: company,
      transactions: company.account.all_transactions.ordered
    }
  end

  def create
    if form.valid?
      if form.income?
        Billing.income_to_company company, form.amount_money, details: form.details, order_number: form.order_number, payer: form.payer
        redirect_to admin_company_path(company), success: "Зачислено на счет #{form.amount_money} компании #{company}"
      else
        Billing.outcome_from_company company, form.amount_money, form.details
        redirect_to admin_company_path(company), success: "Списано со счета #{form.amount_money} компании #{company}"
      end
    else
      render :new, locals: {
        transaction: form,
        company: company
      }
    end
  end

  private

  def form
    @form ||= AdminTransactionForm.new(permitted_params)
  end

  def company
    @company ||= Company.find params[:company_id]
  end

  def permitted_params
    params.require( :admin_transaction_form ).permit!
  end
end
