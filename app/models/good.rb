require 'carrierwave/orm/activerecord'

class Good < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :company
  belongs_to :category

  validates :title, presence: true, uniqueness: { scope: :company_id }

  def to_s
    title
  end
end
