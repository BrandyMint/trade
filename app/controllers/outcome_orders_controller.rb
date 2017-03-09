class OutcomeOrdersController < ApplicationController
  inherit_resources
  belongs_to :company
  actions :show, :index, :new, :create
  respond_to :html
  layout 'profile'

  helper_method :company

  private

  def company
    Company.find params[:company_id]
  end

  def outcome_order_params
    params.
      fetch(:outcome_order, {}).
      permit(:amount, requisite_attributes: [ :company_id, :bik, :inn, :kpp, :account_numbe, :poluchatel, :details ])
  end
end
