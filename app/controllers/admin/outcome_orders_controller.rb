class Admin::OutcomeOrdersController < Admin::ApplicationController
  inherit_resources
  defaults :route_prefix => 'admin'
  has_scope :page, :default => 1
  # belongs_to :company
  respond_to :html

  actions :index, :show, :accept, :reject

  private

  def outcome_order_params
    params.require(:outcome_order).permit(:rejected_message)
  end
end