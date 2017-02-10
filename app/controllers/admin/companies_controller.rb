class Admin::CompaniesController < Admin::ApplicationController
  respond_to :html

  def show
    @company = Company.find params[:id]
    respond_with @company
  end

  def index
    render locals: {
      q: q,
      companies: companies,
      search_form: search_form
    }
  end

  def income
    @company = Company.find params[:id]
    respond_with @company
  end

  def start_review
    @company = Company.find params[:id]
    @company.review! current_user
    redirect_to admin_company_path @company
  end

  def reject
    @company = Company.find params[:id]
    @company.reject! current_user, params.require(:company)[:reject_message]
    redirect_to admin_company_path @company
  end

  def accept
    @company = Company.find params[:id]
    @company.accept! current_user
    redirect_to admin_company_path @company
  end

  private

  def company_params
    params.require(:company).permit!
  end

  protected

  def q
    Company.ransack params[:q]
  end

  def search_form
    @search_form ||= SearchForm.new params.fetch(:search_form, {}).permit(:q)
  end

  def companies
    scope = Company.includes(:user, :account)
    scope = scope.search_by_name search_form.q if search_form.q.present?
    scope = scope.ransack(params[:q]).result

    scope.page params[:page]
  end
end
