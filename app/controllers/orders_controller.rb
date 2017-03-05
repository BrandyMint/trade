class OrdersController < ApplicationController
  include ActionView::Helpers::FormOptionsHelper

  before_action :require_login

  def new
    @good = Good.find order_params[:good_id]

    if current_user.companies.reload.any?
      if available_companies(@good).any?
        @order = Order.new order_params.permit!
        authorize @order
        render 'new', locals: { companies_as_options: companies_as_options(@good) }
      else
        render 'new_no_money'
      end
    else
      render 'new_without_company'
    end
  end

  def create
    order = Order.new order_params.merge(user_id: current_user.id)

    authorize order
    message =nil
    order.company.transaction do
      order.save!

      if order.good.prepayment_required?
        Billing.lock_amount order
        message = "На вашем счету зарезервированы средства #{humanized_money_with_symbol order.amount}"
      end
    end

    redirect_to order_path(order), info: message
  end

  def show
    order = Order.find params[:id]
    authorize order

    render locals: { order: order }
  end

  private

  def available_companies(good)
    current_user.companies.includes(:account).to_a.select do |c|
      good.orderable_for_company? c
    end
  end

  def companies_as_options(good)
    disabled = []
    companies = current_user.companies.includes(:account).map do |c|
      amount = humanized_money_with_symbol(c.amount)
      unless good.orderable_for_company?(c)
        amount = "#{amount} НЕДОСТАТОЧНО СРЕДСТВ"
        disabled << c.id
      end
      title = "#{c.name}: #{amount}"
      [title, c.id]
    end
    options_for_select companies, disabled: disabled
  end

  def order_params
    params.require(:order).permit(:company_id, :good_id)
  end
end
