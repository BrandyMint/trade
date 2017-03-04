require 'application_responder'

class ApplicationController < ActionController::Base
  include Pundit
  include RescueErrors
  include MoneyRails::ActionViewExtension

  self.responder = ApplicationResponder

  respond_to :html

  helper_method :current_namespace
  protect_from_forgery with: :exception

  protected

  def current_namespace
    :common
  end

  # Вызфывает Sorcery из require_login
  def not_authenticated
    raise RequireLogin
  end
end
