module BannersHelper
  def active_banners
    Banner.active.where.not(id: shown_banners_ids)
  end

  def shown_banners_ids
    if current_user.present?
      current_user.shown_banners
    else
      session[:shown_banners] || []
    end
  end

  def banner_badge(b)
    if b.is_active?
      content_tag :div, 'Активен', class: 'badge badge-primary'
    else
      content_tag :div, 'Отключен', class: 'badge badge-default'
    end
  end
end
