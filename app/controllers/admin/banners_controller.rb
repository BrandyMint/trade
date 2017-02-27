class Admin::BannersController < Admin::ApplicationController
  respond_to :html

  def show
    @banner = Banner.find params[:id]
    respond_with @banner
  end

  def new
    @banner = Banner.new
    respond_with @banner
  end

  def edit
    @banner = Banner.find params[:id]
    respond_with @banner
  end

  def create
    @banner = Banner.create banner_params
    respond_with @banner, location: -> { admin_banners_path }
  end

  def update
    @banner = Banner.find params[:id]
    @banner.update banner_params
    respond_with @banner, location: -> { admin_banners_path }
  end

  def destroy
    @banner = Banner.find params[:id]
    @banner.destroy
    respond_with @banner, location: -> { admin_banners_path }
  end

  def index
    @banners = Banner.ordered
    respond_with @banners
  end

  private

  def banner_params
    params.require(:banner).permit(:text, :subject, :is_active)
  end
end
