class OrderMailer < ApplicationMailer
  include ActionView::Helpers::UrlHelper

  def created(order, user)
    setup_assigns order
    action_mail user
  end

  def complete(order, user)
    setup_assigns order
    action_mail user
  end

  def cancel(order, user)
    setup_assigns order
    action_mail user
  end

  private

  def setup_assigns order
    @order = order
    @url = order_url order
    @link = link_to "##{order.number}", @url
  end
end
