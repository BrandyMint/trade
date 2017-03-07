class Admin::GoodsController < Admin::ApplicationController
  include GoodsScope

  def show
    @good = Good.find params[:id]
    respond_with @good
  end

  def index
    render locals: {
      goods: goods_index,
      search_form: search_form
    }
  end

  private

  def goods_scope
    Good.all
  end
end
