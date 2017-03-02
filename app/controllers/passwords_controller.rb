class PasswordsController < ApplicationController
  respond_to :html

  layout 'profile'

  def update
    require_login
    @user = current_user
    @user.update user_params
    respond_with @user, location: -> { edit_password_path }
  end

  def edit
    require_login
    @user = current_user
    respond_with @user
  end

  private

  def user_params
    params.require( :user ).permit(:password, :password_confirmation)
  end
end
