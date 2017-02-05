class CompanyGoodsController < ApplicationController
  after_action :verify_authorized
  respond_to :html

  def new
    authorize Good
    @good = Good.new
    respond_with @good
  end

  def create
    authorize Good
    @good = company.goods.create permitted_params
    respond_with @good, location: -> { good_path(@good) }
  end

  def edit
    @good = Good.find params[:id]
    authorize @good
    respond_with @good
  end

  def update
    @good = Good.find params[:id]
    authorize @good
    @good.update permitted_params
    respond_with @good, location: -> { good_path(@good) }
  end

  def index
    render locals: { goods: company.goods.view_order }
  end

  private

  def company
    @company ||= Company.find params[:company_id]
  end
end
