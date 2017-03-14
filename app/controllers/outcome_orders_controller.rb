class OutcomeOrdersController < ApplicationController
  before_action :require_login
  inherit_resources
  belongs_to :company
  actions :show, :index, :new, :create
  respond_to :html

  layout 'profile'

  helper_method :company

  private

  def company
    current_user.companies.find params[:company_id]
  end

  def build_resource_params
    [
      my_resource_params
    ]
  end

  def my_resource_params
    if params[:outcome_order].present?
      outcome_order_params
    else
      {
        amount: company.amount,
        requisite_attributes: build_requisite_attributes
      }
    end
  end

  def build_requisite_attributes
    if company.last_used_requisite.present?
      company.last_used_requisite.attributes.slice('inn', 'kpp', 'bik', 'poluchatel', 'account_number', 'bank_name', 'ks_number')
    else
      {
        poluchatel: company.name,
        inn: company.inn,
        kpp: company.kpp
      }
    end
  end

  def outcome_order_params
    params.
      fetch(:outcome_order, {}).
      permit(:amount, requisite_attributes: [ :company_id, :bik, :inn, :kpp, :bank_name, :account_number, :ks_number, :poluchatel, :details ]).
      merge user_id: current_user.id
  end
end
