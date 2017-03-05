class BannersController < ApplicationController
  def destroy
    banner = Banner.find params[:id]

    if current_user.present?
      current_user.shown_banner banner.id
    else
      add_shown_banner banner.id
    end

    render plain: 'ok'
  end
end
