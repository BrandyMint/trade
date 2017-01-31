class CompanyGoodsController < ApplicationController
  respond_to :html

  def index
    render locals: { goods: current_company.goods.view_order }
  end
end
