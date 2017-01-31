class CompaniesController < ApplicationController
  before_filter :require_login, except: :index

  def index
    @companies = Company.order(:id)
    respond_with @companies
  end

  def new
    @company = Company.new
    respond_with @company, layout: 'simple'
  end

  def create
    @company = current_user.create_company permitted_params
    respond_with @company
  end

  def show
    @company = Company.find params[:id]
    respond_with @company
  end

  private

  def permitted_params
    params[:company].permit(:name, :inn, :ogrn, :form)
  end
end
