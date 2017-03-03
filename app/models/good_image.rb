
# TODO Пока эта модель не используется
class GoodImage < ApplicationRecord
  include FileSize

  belongs_to :good, counter_cache: :images_count
  mount_uploader :image, ImageUploader
end
