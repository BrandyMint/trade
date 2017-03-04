class UsersController < ApplicationController
  respond_to :html

  def new
    @user = User.new
    respond_with @user, layout: 'simple'
  end

  def create
    @user = User.new user_params
    @user.save!
    auto_login @user if @user.persisted?

    redirect_to new_company_path
  rescue ActiveRecord::RecordInvalid
    render :new, layout: 'simple'
  end

  def update
    require_login

    @user = User.find params[:id]
    authorize @user
    @user.update user_params
    respond_with @user, layout: 'profile'
  end

  def edit
    require_login
    @user = User.find params[:id]
    authorize @user
    respond_with @user, layout: 'profile'
  end

  private

  def user_params
    params.require( :user ).permit(:phone, :name, :email, :password, :password_confirmation)
  end
end
