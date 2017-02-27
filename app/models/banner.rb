class Banner < ApplicationRecord
  include ActionView::Helpers::TextHelper
  scope :active, -> { where is_active: true }
  scope :ordered, -> { order 'id desc' }

  validates :subject, presence: true

  def flash_type
    :info
  end
end
