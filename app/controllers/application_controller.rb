require 'application_responder'

class ApplicationController < ActionController::Base
  include RescueErrors
  self.responder = ApplicationResponder

  respond_to :html

  protect_from_forgery with: :exception

  protected

  def not_authenticated
    raise NoAuthentication
  end
end
