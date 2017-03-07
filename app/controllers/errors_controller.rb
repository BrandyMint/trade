class ErrorsController < ApplicationController
  layout 'simple'

  def show
    code = params[:code] || 'unknown'
    render locals: { code: code }, format: :html
  end
end
