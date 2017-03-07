class UserOrdersController < ApplicationController
  before_filter :require_login

  layout 'profile'

  def index
    render locals: {
      income_orders_count: income_orders.count,
      outcome_orders_count: outcome_orders.count,
      type: type,
      orders: orders_index.order('orders.id desc').page(params[:page])
    }
  end

  private

  def type
    if params[:type] == 'outcome'
      'outcome'
    else
      'income'
    end
  end

  def income_orders
    Order.
      includes(good: [:company]).
      where(goods: { company_id: 1 })
  end

  def outcome_orders
    current_user.orders
  end

  def orders_index
    if type == 'income'
      income_orders
    else
      outcome_orders
    end
  end
end
