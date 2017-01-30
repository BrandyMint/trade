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
  end

  def edit
  end

  private

  def user_params
    params.require( :user ).permit(:email, :password, :password_confirmation)
  end
end
