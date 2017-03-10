require 'carrierwave/orm/activerecord'

class Good < ApplicationRecord
  include PgSearch
  include Workflow

  mount_uploader :image, ImageUploader

  belongs_to :company, counter_cache: true
  has_one :user, through: :company
  belongs_to :category

  has_many :orders

  counter_culture :category,
    column_name: proc {|good| good.is_available? ? 'goods_count' : nil },
    column_names: {
      ['goods.workflow_state = ? and is_company_verified', :published] => :goods_count
    },
    touch: true

  # TODO перевести изображения товара с поля image в таблицу GoodImage
  # has_many :images, class_name: 'GoodImage'

  pg_search_scope :search_by_title,
    against: { title: 'A', details: 'B' },
    using: { tsearch: { negation: true, dictionary: 'russian', prefix: true } }

  scope :published, -> { where workflow_state: :published }
  scope :view_order, -> { order 'goods.id desc' }
  scope :active, -> { where workflow_state: [:published, :draft] }
  scope :company_verified, -> { where is_company_verified: true }
  scope :available, -> { published.company_verified }

  validates :title, presence: true, uniqueness: { scope: :company_id }
  validates :company, presence: true
  validates :category, presence: true
  validates :price, numericality: { greater_than: 0 }, if: :price?

  validate :prepay_with_price

  workflow do
    state :draft do
      event :publish, :transitions_to => :published
      event :trash, :transitions_to => :trash
    end
    state :published do
      event :draft, :transitions_to => :draft
      event :trash, :transitions_to => :trash
    end
    state :trash do
      event :draft, :transitions_to => :trash
      event :published, :transitions_to => :trash
    end
  end

  def is_available?
    is_company_verified? && published?
  end

  def amount
    return if price.nil?
    Money.new price*100
  end

  def to_s
    title
  end

  def orderable_for_company?(company)
    !prepayment_required? || amount.nil? || amount <= company.amount
  end

  private

  def prepay_with_price
    if prepayment_required? && price.blank?
      errors.add :price, 'У предложений с предоплатой должна быть цена'
    end
  end
end
