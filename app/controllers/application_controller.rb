require 'application_responder'

class ApplicationController < ActionController::Base
  include Pundit
  include RescueErrors
  include MoneyRails::ActionViewExtension
  include BannersSupport

  self.responder = ApplicationResponder

  respond_to :html

  before_action :setup_gon

  helper_method :current_namespace
  helper_method :can_supersignin?
  protect_from_forgery with: :exception

  protected

  def current_namespace
    :common
  end

  def can_supersignin?
    Rails.env.development? || (logged_in? && current_user.is_admin?)
  end

  # Вызфывает Sorcery из require_login
  def not_authenticated
    raise RequireLogin
  end

  def setup_gon
    gon.document_types = DocumentUploader::EXTENSION_WHITE_LIST.map{ |e| ".#{e}"}.join(',')
  end
end
