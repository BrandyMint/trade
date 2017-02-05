module ApplicationHelper
  def humanized_thousand_money_with_symbol(amount)
    amount = amount.to_f/1000
    amount = amount.to_i if amount.to_i == amount
    content_tag :span, "#{amount} тыс.руб.", class: 'text-nowrap'
  end

  def show_field(record, attribute)
    value = record.send attribute
    value = I18n.l value, format: :human if value.is_a? Time
    title = I18n.t attribute, scope: [:activerecord, :attributes, record.class.model_name.i18n_key]
    content_tag :p do
      "#{title}: #{value}"
    end
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
      'OnlineTrade: админка'
    else
      'OnlineTrade'
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

  def navbar_link_to(title, href, count: nil, active: nil)
    active = is_active_link? href, :inclusive if active.nil?
    active_class = active ? 'active' : ''

    title << content_tag(:small, " (#{count})", class: 'text-muted') if count.present?
    content_tag :li, class: "nav-item #{active_class}" do
      link_to title.html_safe, href, class: 'nav-link'
    end
  end
end
