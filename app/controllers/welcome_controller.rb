class WelcomeController < ApplicationController
  include SearchFormConcern

  def index
    render 'goods/index', locals: { goods: goods_index }
  end
end
