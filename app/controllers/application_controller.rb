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

  attr_reader :current_namespace

  def not_authenticated
    raise NoAuthentication
  end
end
