class Admin::OutcomeOrdersController < ApplicationController
  inherit_resources
  defaults :route_prefix => 'admin'
  respond_to :html

  actions :index, :show, :accept, :reject

  private

  def outcome_order_params
    params.require(:outcome_order).permit(:rejected_message)
  end
end
