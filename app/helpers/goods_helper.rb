module GoodsHelper
  def good_workflow_states_collection
    %w(draft published).map do |state|
      [good_workflow_state_text(state), state]
    end
  end

  def good_prepayment_state(good)
    if good.prepayment_required?
      content_tag :span, 'по предоплате', class: 'badge badge-info'
    else
      content_tag :span, 'постоплата', class: 'badge badge-success'
    end
  end

  def good_workflow_state(state)
    if state == 'draft'
      klass = 'badge badge-default'
    else
      klass = 'badge badge-success'
    end
    content_tag :span, good_workflow_state_text(state), class: klass
  end

  def good_workflow_state_text(state)
    content_tag :span, t(state, scope: [:enumerize, :good_workflow_states])
  end

  def company_goods_count(company)
    if company.goods_count > 0
      link_to "#{company.goods_count} поз.", goods_path(company_id: company.id)
    else
      content_tag :span, 'нет предложений', class: 'text-muted'
    end
  end
  def good_details(good)
    content_tag :span, class: 'text-muted' do
      good.details || 'нет описания'
    end
  end
end
