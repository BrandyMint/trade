class CompanyDocument < ApplicationRecord
  extend Enumerize
  include ModerationState
  include FileSize

  belongs_to :company, counter_cache: :documents_count

  mount_uploader :file, DocumentUploader

  enumerize :category,
    in: DocumentTypes::All,
    predicates: true,
    scope: true
end
