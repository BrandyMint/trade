class CompanyDocument < ApplicationRecord
  extend Enumerize
  include ModerationState

  belongs_to :company, counter_cache: true

  mount_uploader :file, DocumentUploader

  delegate :size, to: :file, prefix: true
end
