module ApplicationHelper
  def nav_link_class(active)
    active ? 'nav-link active' : 'nav-link'
  end

  def humanized_money(amount)
    "#{amount} руб."
  end

  def application_title
    'OnlineTrade'
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

  def navbar_link_to(title, href, count: nil, active: nil)
    active = is_active_link? href, :inclusive if active.nil?
    active_class = active ? 'active' : ''

    title << content_tag(:small, " (#{count})", class: 'text-muted') if count.present?
    content_tag :li, class: "nav-item #{active_class}" do
      link_to title.html_safe, href, class: 'nav-link'
    end
  end
end
