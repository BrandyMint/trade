require 'application_responder'

class ApplicationController < ActionController::Base
  include Pundit
  include RescueErrors

  self.responder = ApplicationResponder

  respond_to :html

  helper_method :current_company
  helper_method :current_namespace

  protect_from_forgery with: :exception

  protected

  attr_reader :current_namespace

  def authorize_moderated
    require_login
    raise NoAcceptedCompany unless current_company.try(:accepted?)
  end

  def current_company
    current_user.company
  end

  def not_authenticated
    raise NoAuthentication
  end
end
