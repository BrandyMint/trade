class Admin::PagesController < Admin::ApplicationController
  inherit_resources
  defaults :route_prefix => 'admin'
  respond_to :html

  def show
    redirect_to page_path params[:id]
  end

  private

  def page_params
    params.require(:page).permit(:title, :slug, :is_active, :text)
  end
end
