class GoodsController < ApplicationController
  include SearchFormConcern
  include GoodsScope
  before_action :require_login, except: [:index, :show]

  def new
    @good = Good.new
    @companies = current_user.companies.ordered

    if @companies.any?
      render 'new', layout: 'profile'
    else
      render 'no_company'
    end
  end

  def create
    @good = Good.create permitted_params

    respond_with @good, location: -> { good_path @good }
  end

  def index
    render locals: { goods: goods_index }
  end

  def edit
    @good = Good.find params[:id]
    authorize @good
    respond_with @good, layout: 'profile'
  end

  def update
    @good = Good.find params[:id]
    authorize @good
    @good.update permitted_params

    @good.draft! if params[:draft] && !@good.draft?
    @good.publish! if params[:publish] && !@good.published?
    respond_with @good, location: -> { good_path @good }, layout: 'profile'
  end

  def show
    @good = Good.find params[:id]
    authorize @good
    respond_with @good
  end

  def destroy
    @good = Good.find params[:id]
    authorize @good
    @good.trash!
    redirect_to user_goods_path, success: "Товар #{@good.title} удален"
  end

  private

  def render_register(template)
    if current_user.companies.with_draft_state.exists?
      render template, locals: { company: current_user.companies.with_draft_state.first }, layout: 'simple'

    elsif current_user.companies.with_awaiting_review_state.exists?
      render template, locals: { review_company: current_user.companies.with_awaiting_review_state.first }, layout: 'simple'

    else
      render template, locals: { company: build_company }, layout: 'simple'
    end
  end

  def permitted_params
    params[:good].permit(:title, :price, :workflow_state, :prepayment_required, :details, :image, :remove_image, :image_cache, :remote_image_url, :company_id, :category_id)
  end
end
