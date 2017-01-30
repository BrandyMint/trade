class Category < ApplicationRecord
  def to_s
    title
  end

  def to_label
    to_s
  end
end
