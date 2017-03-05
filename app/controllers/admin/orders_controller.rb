class Admin::OrdersController < Admin::ApplicationController
  def index
    render locals: { orders: orders }
  end

  def show
    render locals: { order: order }
  end

  def complete
    order.complete! current_user
    redirect_to admin_order_path(order), success: 'Средсва переданы продавцы'
  end

  def cancel
    order.cancel! current_user
    redirect_to admin_order_path(order), success: 'Средсва возвращены покупателю'
  end
  private

  def order
    @order ||= Order.find params[:id]
  end

  def orders
    Order.order('id desc').includes(:company, good: [:company]).page(params[:page])
  end
end
