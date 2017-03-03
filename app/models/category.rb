class Category < ApplicationRecord
  belongs_to :parent, class_name: 'Category'

  scope :ordered, -> { order :title }
  scope :with_goods, -> { where 'goods_count > 0' }

  def to_s
    title
  end
end
