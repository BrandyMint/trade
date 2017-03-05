class ErrorsController < ApplicationController
  layout 'simple'

  def show
    code = params[:code] || 404
    title = I18n.t :title, scope: [:error_pages, code]
    render locals: { code: code, title: title }
  end
end
