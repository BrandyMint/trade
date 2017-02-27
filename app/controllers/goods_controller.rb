class GoodsController < ApplicationController
  include SearchFormConcern
  # before_filter :require_login, except: [:index, :new]


  def new
    require_login

    if current_user.companies.with_accepted_state.exists?
      @good = Good.new
      respond_with @good
    else
      render_register 'new_unregistered'
    end
  end

  def index
    render locals: { goods: goods_index }
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

  def render_register(template)
    if current_user.companies.with_draft_state.exists?
      render template, locals: { company: current_user.companies.with_draft_state.first }, layout: 'simple'

    elsif current_user.companies.awaiting_reviews.exists?
      render template, locals: { review_company: current_user.companies.with_awaiting_review_state.first }, layout: 'simple'

    else
      render template, locals: { company: build_company }, layout: 'simple'
    end
  end

  def permitted_params
    params[:good].permit(:title, :price, :details, :image, :remove_image, :image_cache, :remote_image_url, :category_id)
  end

end
