class GoodsController < ApplicationController
  # before_filter :require_login, except: [:index, :new]

  helper_method :search_form

  def new
    require_login

    if current_user.companies.accepted.exists?
      @good = Good.new
      respond_with @good
    else

      if current_user.companies.draft.exists?
        render 'new_unregistered', locals: { company: current_user.companies.draft.first }, layout: 'simple'

      elsif current_user.companies.waits_reviews.exists?
        render 'new_unregistered', locals: { review_company: current_user.companies.waits_review.first }, layout: 'simple'

      else
        render 'new_unregistered', locals: { company: build_company }, layout: 'simple'
      end
    end
  end

  def index
    @goods = Good.includes(:company, :category).search_by_title search_form.q
    respond_with @goods
  end

  def show
    @good = Good.find params[:id]
    authorize @good
    respond_with @good
  end

  def destroy
    @good = Good.find params[:id]
    authorize @good
    @good.destroy!
    redirect_to company_goods_path, success: "Товар #{@good.title} удален"
  end

  private

  def permitted_params
    params[:good].permit(:title, :price, :details, :image, :remove_image, :image_cache, :remote_image_url, :category_id)
  end

  def search_form
    @search_form ||= SearchForm.new params.fetch(:search_form, {}).permit(:q)
  end
end
