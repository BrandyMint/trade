module GoodsHelper
  def good_price(good)
    if logged_in?
      buffer = humanized_price(good.amount)
      buffer << content_tag(:span, good_prepayment_icon(good), class: 'ml-2')
      buffer.html_safe
    else
      content_tag :div, 'цена',
        class: 'badge badge-default',
        data: { toggle: :popover, placement: :top, content: good_price_popover_content, html: true, delay: { show: 300, hide: 2000 }, trigger: :hover },
        title: 'Цены доступны только для зарегистрированных'
    end
  end

  def good_price_popover_content
    link_to 'Зарегистрироваться', signup_path, class: 'btn btn-success'
  end

  def prepayment_collection
    [['Обязательна', true], ['Не требуется', false]]
  end

  def good_buy_link(good)
    link_to new_order_path(order: { good_id: good.id }), class: 'btn btn-outline-success' do
      fa_icon 'cart-arrow-down', text: 'Купить'
    end
  end

  def good_prepayment_icon(good)
    if good.prepayment_required?
      content_tag :span, data: { toggle: :tooltip }, title: 'Требуется предоплата' do
        fa_icon 'hand-o-up'
      end
    else
      content_tag :span, data: { toggle: :tooltip }, title: 'Без предоплаты' do
        fa_icon 'hand-o-left'
      end
    end
  end

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
    case state
    when 'draft'
      klass = 'badge badge-info'
    when 'published'
      klass = 'badge badge-success'
    else
      klass = 'badge badge-default'
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
