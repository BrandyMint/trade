module OrdersHelper
  def order_workflow_state_text(state)
    content_tag :span, t(state, scope: [:enumerize, :order_workflow_states])
  end
end
