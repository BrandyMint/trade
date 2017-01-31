class GoodsController < ApplicationController
  before_filter :require_login, except: :index

  helper_method :search_form

  def new
    @good = Good.new
    respond_with @good
  end

  def create
    @good = current_company.goods.create permitted_params
    respond_with @good, location: -> { good_path(@good) }
  end

  def index
    @goods = Good.search_by_title search_form.q
    respond_with @goods
  end

  def show
    @good = Good.find params[:id]
    respond_with @good
  end

  private

  def permitted_params
    params[:good].permit(:title, :price, :details, :image, :remove_image, :image_cache, :image_url, :category_id)
  end

  def search_form
    @search_form ||= SearchForm.new params.fetch(:search_form, {}).permit(:q)
  end
end
