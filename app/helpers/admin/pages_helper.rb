module Admin::PagesHelper
  def page_active_flag is_active
    if is_active
      content_tag :span, 'активна', class: 'badge badge-info'
    else
      content_tag :span, 'отключена', class: 'badge badge-default'
    end
  end
end
