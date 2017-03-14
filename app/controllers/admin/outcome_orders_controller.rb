class Admin::OutcomeOrdersController < Admin::ApplicationController
  inherit_resources
  defaults :route_prefix => 'admin'
  # has_scope :page, :default => 1
  # belongs_to :company
  respond_to :html

  actions :index, :show, :accept, :reject

  private

  def collection
    @outcome_orders ||= end_of_association_chain.ordered.page(params[:page])
  end

  def outcome_order_params
    params.require(:outcome_order).permit(:rejected_message)
  end
end
