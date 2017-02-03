class OpenbillCategory < ApplicationRecord
  COMPANIES_NAME = 'Организации'

  has_many :openbill_accounts

  def self.companies
    OpenbillCategory.find_or_create_by name: COMPANIES_NAME
  end
end
