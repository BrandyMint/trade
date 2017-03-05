class UserOrdersController < ApplicationController
  before_filter :require_login

  layout 'profile'

  def index
    render locals: {
      orders: orders_index
    }
  end

  private
  def orders_index
    current_user.orders.order('id desc').page params[:page]
  end
end
