class GoodImage < ApplicationRecord
  belongs_to :good, counter_cache: :images_count
  mount_uploader :image, ImageUploader
end
