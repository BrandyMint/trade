module OutcomeOrdersHelper
  def outcome_order_state(state)
    content_tag :div, state, class: 'badge badge-info'
  end
end
