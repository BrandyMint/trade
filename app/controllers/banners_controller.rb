class BannersController < ApplicationController
  def destroy
    banner = Banner.find params[:id]

    if current_user.present?
      current_user.shown_banner banner.id
    else
      list = session[:shown_banner] ||= []
      session[:shown_banner] = list.uniq
    end

    render text: 'ok'
  end
end
