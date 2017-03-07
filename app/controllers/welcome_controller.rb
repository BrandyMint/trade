class WelcomeController < ApplicationController
  include GoodsScope

  def index
    render 'goods/index', locals: {
      goods: goods_index,
      search_form: search_form
    }
  end
end
