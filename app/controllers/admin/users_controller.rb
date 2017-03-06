class Admin::UsersController < Admin::ApplicationController
  def signin
    user = User.find params[:id]
    auto_login user
    redirect_to admin_root_url, { success: "Вы вошли как #{user}" }
  end

  def index
    render locals: { search_form: search_form, users: users }
  end

  private

  def search_form
    @search_form ||= AdminUsersSearchForm.new params.fetch(:q, {}).permit!
  end

  def users
    scope = User.order('id desc')

    scope = scope.ransack(params[:q]).result

    scope.page(params[:page])
  end
end
