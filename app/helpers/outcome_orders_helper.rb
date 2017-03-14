module OutcomeOrdersHelper
  CSS_CLASSES = {
    'draft' => 'badge badge-info',
    'accepted' => 'badge badge-success',
    'rejected' => 'badge badge-warning',
  }

  def requisite_fields
    %w(poluchatel inn kpp bik bank_name account_number ks_number)
  end

  def outcome_order_state(state)
    label = I18n.t state, scope: [:enumerize, :outcome_order_states]
    content_tag :div, label, class: CSS_CLASSES[state]
  end
end
