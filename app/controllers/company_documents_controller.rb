class CompanyDocumentsController < ApplicationController
  before_filter :require_login, except: :index

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

  private

  def company
    @company ||= Company.find params[:company_id]
  end
end
