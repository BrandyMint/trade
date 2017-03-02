class UsersController < ApplicationController
  respond_to :html


  def new
    @user = User.new
    respond_with @user
  end

  def create
    @user = User.create user_params
    auto_login @user if @user.persisted?
    respond_with @user, location: -> { new_company_path }
  end

  def update
    require_login

    @user = current_user
    @user.update user_params
    respond_with @user, layout: 'profile'
  end

  def edit
    require_login
    @user = current_user
    respond_with @user, layout: 'profile'
  end

  private

  def user_params
    params.require( :user ).permit(:phone, :name, :email)
  end
end
