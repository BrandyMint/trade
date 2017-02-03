class Admin::ApplicationController < ApplicationController
  before_action :require_admin
  before_action :set_admin_namespace
  layout 'admin/application'

  private

  def set_admin_namespace
    @current_namespace = :admin
  end

  def require_admin
    require_login
    raise AdminRequired unless current_user.is_admin?
  end
end
