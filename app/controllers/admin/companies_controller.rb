class Admin::CompaniesController < Admin::ApplicationController
  inherit_resources
  defaults route_prefix: 'admin'

  respond_to :html

  private

  def company_params
    params.require(:company).permit!
  end

  protected
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.includes(:user, :account).page(params[:page]))
  end
end
