require 'carrierwave/orm/activerecord'

class Good < ApplicationRecord
  include PgSearch

  mount_uploader :image, ImageUploader

  pg_search_scope :search_by_title,
    against: { title: 'A', details: 'B' },
    using: { tsearch: { negation: true, dictionary: 'russian', prefix: true } }

  scope :view_order, -> { order 'id desc' }

  belongs_to :company
  belongs_to :category

  validates :title, presence: true, uniqueness: { scope: :company_id }

  def to_s
    title
  end
end
