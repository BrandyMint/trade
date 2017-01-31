require 'application_responder'

class ApplicationController < ActionController::Base
  include RescueErrors
  self.responder = ApplicationResponder

  respond_to :html

  helper_method :current_company

  protect_from_forgery with: :exception

  protected

  def current_company
    current_user.company
  end

  def not_authenticated
    raise NoAuthentication
  end
end
