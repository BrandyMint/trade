class GoodsController < ApplicationController
  # before_filter :require_login, except: [:index, :new]

  helper_method :search_form

  def new
    require_login

    if current_user.companies.accepted.exists?
      @good = Good.new
      respond_with @good
    else
      render_register 'new_unregistered'
    end
  end

  def index
    if params[:company_id].present?
      redirect_to company_path params[:company_id]
    else
      @goods = goods_index
      respond_with @goods
    end
  end

  def show
    @good = Good.find params[:id]
    authorize @good
    respond_with @good
  end

  def buy
    require_login
    @good = Good.find params[:id]

    if current_user.companies.accepted.exists?
      @good = Good.new
      respond_with @good
    else
      render_register 'buy_unregistered'
    end
  end

  def destroy
    @good = Good.find params[:id]
    authorize @good
    @good.destroy!
    redirect_to company_goods_path, success: "Товар #{@good.title} удален"
  end

  private

  def goods_index
    scope = goods_scope
    scope = scope.search_by_title search_form.q if search_form.q.present?

    scope.page params[:page]
  end

  def goods_scope
    scope = Good.includes(:company, :category)

    if params[:company_id].present?
      scope = scope.where(company_id: params[:company_id])
    end

    scope
  end

  def render_register(template)
    if current_user.companies.draft.exists?
      render template, locals: { company: current_user.companies.draft.first }, layout: 'simple'

    elsif current_user.companies.waits_reviews.exists?
      render template, locals: { review_company: current_user.companies.waits_review.first }, layout: 'simple'

    else
      render template, locals: { company: build_company }, layout: 'simple'
    end
  end

  def permitted_params
    params[:good].permit(:title, :price, :details, :image, :remove_image, :image_cache, :remote_image_url, :category_id)
  end

  def search_form
    @search_form ||= SearchForm.new params.fetch(:search_form, {}).permit(:q)
  end
end
