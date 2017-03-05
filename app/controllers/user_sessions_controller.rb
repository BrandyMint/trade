class UserSessionsController < ApplicationController
  layout 'simple'

  def new
    render locals: { user_session: user_session }
  end

  def supersignin
    if can_supersignin?
      user = User.find params[:id]
      auto_login user
      if user.is_admin?
        redirect_to admin_root_path
      else
        redirect_to :back
      end
    else
      flash[:danger] = 'Ай-яй'
    end
  end

  def create
    if login user_session.email, user_session.password, user_session.remember
      redirect_back_or_to root_url, { success: "Добро пожаловать, #{current_user}!" }
    else
      user_session.errors.add :email, 'Нет такого пользователя или пароль не верный'
      render :new, locals: { user_session: user_session }
    end
  end

  def destroy
    logout if logged_in?
    redirect_back_or_to root_url, { success: 'Вы вышли из системы' }
  end

  private

  def user_session
    @user_session ||= UserSession.new params.fetch( :user_session, {} ).permit(:email, :password, :remember)
  end
end
