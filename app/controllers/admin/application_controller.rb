class Admin::ApplicationController < ApplicationController
  before_action :require_admin
  layout 'admin/application'

  private

  def current_namespace
    :admin
  end

  def require_admin
    require_login
    raise AdminRequired unless current_user.is_admin?
  end
end
