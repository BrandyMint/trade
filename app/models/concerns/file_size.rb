module FileSize
  extend ActiveSupport::Concern

  included do
    validates :file_size, file_size: { less_than: 12.megabyte,
                                       greater_than_or_equal_to: 20.kilobytes }

    before_save :set_file_size
  end

  private

  def set_file_size
    if file.present? && file_changed?
      self.content_type = file.file.content_type
      self.file_size = file.file.size
    end
  end
end
