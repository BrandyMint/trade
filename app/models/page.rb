class Page < ApplicationRecord
  include RankedModel
  extend FriendlyId
  ranks :row_order

  friendly_id :title, use: [:slugged, :finders]

  scope :ordered, -> { rank(:row_order) }
  scope :active, -> { where is_active: true }
  scope :for_view, -> { active.ordered }

  validates :title, presence: true, uniqueness: true
  validates :text, presence: true
  validates :slug, presence: true, uniqueness: true

  private

  def should_generate_new_friendly_id?
    slug.blank?
  end
end
