class UserSessionsController < ApplicationController
  def new
    render locals: { user: User.new }
  end

  def create
    if login params[:email], params[:password], params[:remember]
      redirect_back_or_to root_url
    else
      render locals: params.slice(:email, :password, :remember)
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end
