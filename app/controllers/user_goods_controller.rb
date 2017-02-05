class UserGoodsController < ApplicationController
  respond_to :html

  before_filter :require_login

  layout 'profile'

  def index
    render locals: { goods: goods }
  end

  private

  def goods
    current_user.goods.view_order.page params[:page]
  end
end
