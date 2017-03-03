require 'carrierwave/orm/activerecord'

class Good < ApplicationRecord
  include PgSearch
  include Workflow

  mount_uploader :image, ImageUploader

  belongs_to :company, counter_cache: true
  belongs_to :category, counter_cache: true
  # has_many :images, class_name: 'GoodImage'

  pg_search_scope :search_by_title,
    against: { title: 'A', details: 'B' },
    using: { tsearch: { negation: true, dictionary: 'russian', prefix: true } }

  scope :published, -> { where workflow_state: :published }
  scope :view_order, -> { order 'id desc' }

  validates :title, presence: true, uniqueness: { scope: :company_id }
  validates :company, presence: true
  validates :category, presence: true

  workflow do
    state :draft do
      event :publicate, :transitions_to => :published
    end
    state :published do
      event :review, :transitions_to => :draft
    end
  end

  def amount
    return if price.nil?
    Money.new price*100
  end

  def to_s
    title
  end
end
