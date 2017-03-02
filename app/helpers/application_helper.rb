module ApplicationHelper
  def next_symbol
    '»'
  end

  def close_button(url=nil)
    url ||= url_for
    buffer = '×'
    link_to buffer, url, class: :close
  end

  def category_link(category)
    link_to category, goods_path(category_id: category), class: 'category-link'
  end

  def transaction_amount(t)
    if t.company.present? && t.outcome?
      content_tag :span, humanized_money_with_symbol(-t.amount), class: 'text-danger'
    else
      content_tag :span, humanized_money_with_symbol(t.amount), class: 'text-success'
    end
  end

  def card(title, &block)
    render layout: 'card', locals: { title: title }, &block
  end

  def q_to_param(attrs = {})
    q = params.fetch(:q, {}).permit!.merge(attrs)

    { q: q.to_h }.to_h
  end

  def q_param(key)
    params.fetch(:q, {}).permit!.fetch key, nil
  end

  def humanized_price(price)
    if price
      # humanized_thousand_money_with_symbol price
      humanized_money_with_symbol(price)
    else
      'цена по договоренности'
    end
  end

  def humanized_thousand_money_with_symbol(amount)
    amount = amount.to_f/1000
    amount = amount.to_i if amount.to_i == amount
    content_tag :span, "#{amount} тыс.руб.", class: 'text-nowrap'
  end

  def show_field(record, attribute)
    value = record.send attribute
    value = l value, format: :short if value.is_a? Time
    title = t attribute, scope: [:activerecord, :attributes, record.class.model_name.i18n_key]
    render 'field', title: title, value: value
  end

  def paginate objects, options = {}
    # https://github.com/klacointe/bootstrap-kaminari-views/tree/bootstrap4
    options.reverse_merge!( theme: 'twitter-bootstrap-4', pagination_class: 'pagination-sm' )

    super( objects, options )
  end

  def phone_to(phone)
    return unless phone.present?
    link_to phone, "tel:#{phone}"
  end

  def reset_password_hint(email)
    link_to 'Вспомнить пароль', new_password_reset_path(password_reset: { email: email }), class: 'password_reset-link'
  end

  def nav_link_class(active)
    active ? 'nav-link active' : 'nav-link'
  end

  def application_title
    if current_namespace == :admin
      'Online-Prodaja.Club: админка'
    else
      'Online-Prodaja.Club'
    end
  end

  def destroy_button(resource)
    last_resource = resource.is_a?(Array) ? resource.last : resource
    return unless last_resource.persisted?
    link_to 'Удалить',
      url_for(resource),
      method: :delete,
      data: { confirm: 'Удалить?' },
      class: 'btn btn-outline-danger'
  end

  def dropdown_link_to(title, href, active: nil)
    active = is_active_link? href, :inclusive if active.nil?
    active_class = active ? 'active' : ''

    link_to title, href, class: "dropdown-item #{active_class}"
  end

  def check_circle(flag)
    (flag ? fa_icon('check-circle-o lg') : fa_icon('circle-o lg')).html_safe
  end

  def active_class(css_class, active)
    active ? "#{css_class} active" : css_class
  end

  def title_with_count(title, count = nil)
    if count.to_i > 0
      "#{title} (#{count})"
    else
      title
    end
  end

  def navbar_link_to(title, href, count: nil, active: nil)
    active = is_active_link? href, :inclusive if active.nil?
    active_class = active ? 'active' : ''

    title << content_tag(:small, " (#{count})", class: 'text-muted') if count.present?
    content_tag :li, class: "nav-item #{active_class}" do
      link_to title.html_safe, href, class: 'nav-link'
    end
  end
end
