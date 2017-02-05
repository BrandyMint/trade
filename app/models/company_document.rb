class CompanyDocument < ApplicationRecord
  extend Enumerize
  include ModerationState

  belongs_to :company, counter_cache: :documents_count

  mount_uploader :file, DocumentUploader

  before_save :set_file_size
  validates :file_size, file_size: { less_than: 10.megabyte,
                                     greater_than_or_equal_to: 20.kilobytes }

  enumerize :category,
    in: DocumentTypes.map(&:key),
    predicates: true,
    scope: true

  private

  def set_file_size
    if file.present? && file_changed?
      self.content_type = file.file.content_type
      self.file_size = file.file.size
    end
  end
end
