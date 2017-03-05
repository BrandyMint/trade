class UserGoodsController < ApplicationController
  include SearchFormConcern
  include GoodsScope

  respond_to :html

  before_filter :require_login

  layout 'profile'

  def index
    render locals: {
      search_form: search_form,
      goods_ransack: goods_ransack,
      goods: goods_index
    }
  end

  private

  def goods_ransack
    scope = goods_scope.includes(:company, :category).view_order

    scope = scope.ransack search_form.serializable_hash
  end

  def goods_index
    goods_ransack.result(distinct: true).page(params[:page])
  end

  def search_form
    UserGoodsSearchForm.new params.fetch(:q, {}).permit!
  end

  def goods_scope
    current_user.goods.active
  end
end
