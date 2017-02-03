class CompanyDocumentsController < ApplicationController
  before_filter :require_login, except: :index

  def create
    @document = company.documents.build file: params[:file]
    # TODO
    # authorize @document
    if @document.save!
      render json: @document
    else
      render json: { error: 'Failed to process' }, status: 422
    end
  end

  private

  def company
    @company ||= Company.find params[:company_id]
  end
end
