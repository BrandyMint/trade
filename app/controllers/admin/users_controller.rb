class Admin::UsersController < Admin::ApplicationController
  def signin
    user = User.find params[:id]
    auto_login user
    redirect_to profile_path, { success: "Вы вошли как #{user}" }
  end
end
