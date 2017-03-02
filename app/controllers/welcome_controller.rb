class WelcomeController < ApplicationController
  include SearchFormConcern
  include GoodsScope

  def index
    render 'goods/index', locals: { goods: goods_index }
  end
end
