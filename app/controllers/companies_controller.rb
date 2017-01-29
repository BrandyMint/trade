class CompaniesController < ApplicationController
  before_filter :require_login

  def new
    @company = Company.new
    respond_with @company
  end

  def create
    @company = current_user.companies.create permitted_params
    respond_with @company
  end

  private

  def permitted_params
    params[:company].permit(:name, :inn, :form)
  end
end
