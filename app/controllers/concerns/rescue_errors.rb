module RescueErrors
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError,          with: :user_not_authorized
    rescue_from NoAuthentication,                    with: :user_not_authorized
    rescue_from ActionController::MissingFile,       with: :rescue_not_found
    rescue_from ActiveRecord::RecordNotFound,        with: :rescue_not_found
    rescue_from ActionController::UnknownFormat,     with: :rescue_unknown_format
    # rescue_from HumanizedError,                      with: :rescue_error
  end

  protected

  def user_not_authorized
    render 'authority_forbidden', status: 403, layout: 'simple'
  end

  def rescue_unknown_format
    render status: 406, text: "Unknown Format: #{request.headers['HTTP_ACCEPT']}"
  end

  def rescue_error(error)
    page = if error.is_a? HumanizedError
             ErrorPage.build_from_humanized error
           else
             ErrorPage.build_from_error error
           end
    save_history_path(:error) if respond_to? :save_history_path
    render(
      'humanized_error',
      layout:  'errors',
      formats: 'html',
      status:  400,
      locals:  { current_page: page }
    )
  end

  # Для activeAdmin
  def access_denied(exception)
    redirect_to admin_root_path, alert: exception.message
  end

  # Этот метод автоматически вызывается из authority при получении Authority::SecurityViolation
  def authority_forbidden(error = nil, layout: nil)
    Authority.logger.warn error.message if error.present?

    page = ErrorPage.build :authority_forbidden
    layout ||= error.present? ? 'errors' : 'system'
    render(
      'authority_forbidden',
      status: 403,
      locals: { current_page: page, back_url: request.referer.presence || system_root_path },
      layout: layout,
      formats: 'html'
    )
  end

  def rescue_not_found(error = nil, layout: nil)
    page = ErrorPage.build :not_found

    layout ||= error.present? ? 'errors' : 'system'

    render(
      'not_found',
      status: 404,
      locals: { current_page: page },
      layout: layout,
      formats: 'html'
    )
  end
end
