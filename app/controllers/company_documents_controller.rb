class CompanyDocumentsController < ApplicationController
  before_filter :require_login, except: :index

  skip_before_action :verify_authenticity_token, only: [:delete_by_name]


  def create
    @document = company.documents.build file: params[:file], category: params[:category]
    # TODO
    # authorize @document
    if @document.save!
      render json: @document
    else
      render json: { error: 'Failed to process' }, status: 422
    end
  end

  def show
    # http://googlesystem.blogspot.ru/2009/09/embeddable-google-document-viewer.html
    # send_file(pdf_filename, :filename => "your_document.pdf", :disposition => 'inline', :type => "application/pdf")
    #
  end

  def destroy
    document = company.documents.find params[:id]
    authorize document
    document.destroy
    flash[:success] = 'Документ удален'
    redirect_to :back
  end

  def delete_by_name
    unless params[:name].present?
      render text: 'no document name', status: 202
      return
    end

    name =  CarrierWave::SanitizedFile.new(nil).send :sanitize, params[:name]

    document = company.documents.where(original_filename: name).order(:id).first
    unless document.present?
      render text: 'no document', status: 202
      return
    end
    document.destroy!

    render plain: 'ok'
  end

  private

  def company
    @company ||= Company.find params[:company_id]
  end
end
