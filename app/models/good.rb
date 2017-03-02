require 'carrierwave/orm/activerecord'

class Good < ApplicationRecord
  include PgSearch

  mount_uploader :image, ImageUploader

  belongs_to :company, counter_cache: true
  belongs_to :category, counter_cache: true
  # has_many :images, class_name: 'GoodImage'

  pg_search_scope :search_by_title,
    against: { title: 'A', details: 'B' },
    using: { tsearch: { negation: true, dictionary: 'russian', prefix: true } }

  scope :view_order, -> { order 'id desc' }

  validates :title, presence: true, uniqueness: { scope: :company_id }
  validates :company_id, presence: true

  def amount
    Money.new price*100
  end

  def to_s
    title
  end
end
