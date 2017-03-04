class Admin::UsersController < Admin::ApplicationController
  def signin
    user = User.find params[:id]
    auto_login user
    redirect_to admin_root_url, { success: "Вы вошли как #{user}" }
  end
end
