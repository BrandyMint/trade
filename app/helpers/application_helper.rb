module ApplicationHelper
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

  def navbar_link_to(title, href, active: nil)
    active = is_active_link? href, :inclusive if active.nil?
    active_class = active ? 'active' : ''
    content_tag :li, class: "nav-item #{active_class}" do
      link_to title, href, class: 'nav-link'
    end
  end
end
