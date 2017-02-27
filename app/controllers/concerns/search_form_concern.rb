module SearchFormConcern
  extend ActiveSupport::Concern

  included do
    helper_method :search_form, :current_category
  end

  private

  def goods_index
    scope = goods_scope
    scope = scope.search_by_title search_form.q if search_form.q.present?

    scope.page params[:page]
  end

  def goods_scope
    scope = Good.includes(:company, :category)

    scope = scope.where(company_id: params[:company_id]) if params[:company_id].present?
    scope = scope.where(category_id: params[:category_id]) if params[:category_id].present?

    scope
  end

  def current_category
    return unless params[:category_id]
    Category.find params[:category_id]
  end

  def search_form
    @search_form ||= SearchForm.new params.fetch(:search_form, {}).permit(:q)
  end
end
