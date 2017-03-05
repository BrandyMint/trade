module BannersSupport
  SESSION_KEY = :shown_banners
  extend ActiveSupport::Concern

  included do
    helper_method :session_shown_banners
  end

  private

  def session_shown_banners
    session[SESSION_KEY] ||= []
  end

  def add_shown_banner(banner_id)
    list = session[SESSION_KEY] ||= []
    list << banner_id
    session[SESSION_KEY] = list.uniq
  end
end
