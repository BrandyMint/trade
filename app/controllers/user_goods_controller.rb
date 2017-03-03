class UserGoodsController < ApplicationController
  include SearchFormConcern
  include GoodsScope

  respond_to :html

  before_filter :require_login

  layout 'profile'

  def index
    render locals: { goods: goods_index }
  end

  private

  def goods_scope
    current_user.goods.active
  end
end
