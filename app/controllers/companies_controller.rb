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
    @company = current_user.companies.create permitted_params
    respond_with @company
  end

  def show
    @company = Company.find params[:id]
    respond_with @company
  end

  def edit
    @company = Company.find params[:id]
    authorize @company
    respond_with @company
  end

  def done
    @company = Company.find params[:id]
    authorize @company, :edit?
    @company.done!
    respond_with @company
  end

  def update
    @company = Company.find params[:id]
    authorize @company
    @company.update permitted_params
    respond_with @company
  end

  private

  def permitted_params
    params[:company].permit(:phone, :party, :name, :inn, :ogrn, :form, :kpp, :address, :management_post, :management_name)
  end
end
