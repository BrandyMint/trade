class CompaniesController < ApplicationController
  before_filter :require_login, except: :index

  def index
    @companies = Company.order(:id)
    respond_with @companies
  end

  def new
    @company = build_company
    render locals: { step: params[:step] || @company.registration_step }, layout: 'simple'
  end

  def create
    @company = current_user.companies.create permitted_params

    case @companies.registration_step
    when RegistrationSteps::InfoStep
      raise 'Невозможный шаг регистрации'
    when RegistrationSteps::DocumentsStep
      render 'new', layout: 'simple'
    when RegistrationSteps::ModerationStep
      render 'waits_review'
    else
      raise 'Неизвестный или невозможный шаг регистрации'
    end
  end

  def edit
    @company = Company.find params[:id]
    authorize @company

    render 'new', locals: { step: @company.registration_step }, layout: 'simple'
  end

  def show
    @company = Company.find params[:id]
    respond_with @company
  end

  def done
    @company = Company.find params[:id]
    authorize @company, :edit?

    if @company.all_documents_loaded?
      if @company.draft?
        @company.update_attribute :state, :waits_review
      else
        render 'new', locals: { step: @company.registration_step }, flash: { success: 'Компания ожидает подтверждения модератором' }
      end
    else
      render 'new', locals: { step: @company.registration_step }, flash: { success: 'Не все виды документов загружены' }
    end
  end

  def update
    @company = Company.find params[:id]
    authorize @company
    @company.update permitted_params
    respond_with @company
  end

  private

  def permitted_params
    params[:company].permit(:email, :phone, :party, :name, :inn, :ogrn, :form, :kpp, :address, :management_post, :management_name)
  end

  def build_company
    current_user.companies.draft.new email: current_user.email, phone: current_user.phone
  end
end
