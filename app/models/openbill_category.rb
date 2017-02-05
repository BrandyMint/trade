class OpenbillCategory < ApplicationRecord
  COMPANIES_NAME = 'Организации'
  LOCKED_NAMES = 'Счета блокировки'

  has_many :openbill_accounts

  def self.locked
    OpenbillCategory.find_or_create_by name: LOCKED_NAMES
  end

  def self.companies
    OpenbillCategory.find_or_create_by name: COMPANIES_NAME
  end
end
