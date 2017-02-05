class Admin::CompaniesController < Admin::ApplicationController
  respond_to :html

  def index
    render locals: { companies: companies, search_form: search_form }
  end

  private

  def company_params
    params.require(:company).permit!
  end

  protected

  def search_form
    @search_form ||= SearchForm.new params.fetch(:search_form, {}).permit(:q)
  end

  def companies
    scope = Company.includes(:user, :account)
    scope = scope.search_by_name search_form.q if search_form.q.present?

    scope.page params[:page]
  end
end
