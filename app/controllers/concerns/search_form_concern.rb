module SearchFormConcern
  extend ActiveSupport::Concern

  included do
    helper_method :search_form, :current_category, :current_company
  end

  private

  def current_company
    return unless params[:company_id]
    Company.find params[:company_id]
  end

  def current_category
    return unless params[:category_id]
    Category.find params[:category_id]
  end

  def search_form
    @search_form ||= SearchForm.new params.fetch(:search_form, {}).permit(:q)
  end
end
