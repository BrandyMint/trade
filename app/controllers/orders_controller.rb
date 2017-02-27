class OrdersController < ApplicationController
  before_filter :require_login

  def new
    require_login
    @good = Good.find order_params[:good_id]

    if current_user.companies.with_accepted_state.exists?
      @order = Order.new order_params.permit!
      respond_with @order
    else
      render_register 'buy_unregistered'
    end
  end

  def create
    order = Order.create! order_params.merge(user_id: current_user.id)
    Billing.lock_amount order.company, order.good
    #redirect_back_or_to root_path, success: "На вашем счету зарезервированы средства #{humanized_money_with_symbol order.amount}"
  end

  private

  def order_params
    params.require(:order).permit(:company_id, :good_id)
  end
end
