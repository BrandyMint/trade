class Category < ApplicationRecord
  belongs_to :parent, class_name: 'Category'

  scope :ordered, -> { order :title }

  def to_s
    title
  end
end
