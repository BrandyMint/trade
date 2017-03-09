class PagesController < ApplicationController
  def show
    @page = Page.find params[:id]
    authorize @page
  end
end
