class Category < ApplicationRecord
  belongs_to :parent, class_name: 'Category'

  def to_s
    title
  end
end
