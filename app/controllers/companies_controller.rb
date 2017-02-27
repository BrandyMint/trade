class CompaniesController < ApplicationController
  before_filter :require_login, except: [:index, :show]

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

    case @company.registration_step
    when RegistrationSteps::InfoStep
      render 'new', locals: { step: @company.registration_step }, layout: 'simple'
    when RegistrationSteps::DocumentsStep
      render 'new', layout: 'simple', locals: { step: @company.registration_step }
    when RegistrationSteps::ModerationStep
      render 'awaiting_review'
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
      @company.submit! current_user if @company.draft?
      render 'new', locals: { step: @company.registration_step }, flash: { success: 'Компания ожидает подтверждения модератором' }
    else
      flash.now[:danger] = 'Загрузите сканы регистрационных документов'
      render 'new', locals: { step: @company.registration_step }
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
    current_user.companies.with_draft_state.new email: current_user.email, phone: current_user.phone
  end
end
