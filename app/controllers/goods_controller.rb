class GoodsController < ApplicationController
  # before_filter :require_login, except: [:index, :new]

  helper_method :search_form
  after_action :verify_authorized
  before_action :authorize_moderated, only: [:new, :create, :edit, :update, :destroy]

  def new
    authorize Good
    @good = Good.new
    respond_with @good
  end

  def create
    authorize Good
    @good = current_company.goods.create permitted_params
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
    @goods = Good.search_by_title search_form.q
    respond_with @goods
  end

  def destroy
    @good = Good.find params[:id]
    authorize @good
    @good.destroy!
    redirect_to company_goods_path, success: "Товар #{@good.title} удален"
  end

  def show
    @good = Good.find params[:id]
    respond_with @good
  end

  private

  def permitted_params
    params[:good].permit(:title, :price, :details, :image, :remove_image, :image_cache, :remote_image_url, :category_id)
  end

  def search_form
    @search_form ||= SearchForm.new params.fetch(:search_form, {}).permit(:q)
  end
end
