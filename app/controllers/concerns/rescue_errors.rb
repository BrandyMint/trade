module RescueErrors
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError,          with: :user_not_authorized
    rescue_from NoAuthentication,                    with: :user_not_authorized
    rescue_from AdminRequired,                       with: :user_not_authorized
    rescue_from ActionController::MissingFile,       with: :rescue_not_found
    rescue_from ActiveRecord::RecordNotFound,        with: :rescue_not_found
    rescue_from ActionController::UnknownFormat,     with: :rescue_unknown_format
    # rescue_from Pundit::AuthorizationNotPerformedError, with: :rescue_system_error
    # rescue_from HumanizedError,                      with: :rescue_error
  end

  protected

  def rescue_system_error(error)
    Bugsnag.notify error
    render 'system_error',
      status: 500,
      layout: 'simple'
  end

  def user_not_authorized(error)
    render 'authority_forbidden',
      status: 403,
      locals: build_error_page(error),
      layout: 'simple'
  end

  def build_error_page(error)
    allow_signup = true
    title = 'В доступе отказано'
    message = 'Представьтесь системе'
    if controller_name == 'goods' && action_name == 'new'
      message = 'Для публикации торгового предложения необходимо быть зарегистрированным.'
    end
    if error.is_a? AdminRequired
      message = 'Доступ только для администраторов'
      allow_signup = false
    end

    return {
      title: title,
      allow_signup: allow_signup,
      message: message
    }
  end

  def rescue_unknown_format
    render status: 406, text: "Unknown Format: #{request.headers['HTTP_ACCEPT']}"
  end

  #def rescue_error(error)
    #page = if error.is_a? HumanizedError
             #ErrorPage.build_from_humanized error
           #else
             #ErrorPage.build_from_error error
           #end
    #save_history_path(:error) if respond_to? :save_history_path
    #render(
      #'humanized_error',
      #layout:  'errors',
      #formats: 'html',
      #status:  400,
      #locals:  { current_page: page }
    #)
  #end

  ## Для activeAdmin
  #def access_denied(exception)
    #redirect_to admin_root_path, alert: exception.message
  #end

  ## Этот метод автоматически вызывается из authority при получении Authority::SecurityViolation
  #def authority_forbidden(error = nil, layout: nil)
    #Authority.logger.warn error.message if error.present?

    #page = ErrorPage.build :authority_forbidden
    #layout ||= error.present? ? 'errors' : 'system'
    #render(
      #'authority_forbidden',
      #status: 403,
      #locals: { current_page: page, back_url: request.referer.presence || system_root_path },
      #layout: layout,
      #formats: 'html'
    #)
  #end

  #def rescue_not_found(error = nil, layout: nil)
    #page = ErrorPage.build :not_found

    #layout ||= error.present? ? 'errors' : 'system'

    #render(
      #'not_found',
      #status: 404,
      #locals: { current_page: page },
      #layout: layout,
      #formats: 'html'
    #)
  #end
end
