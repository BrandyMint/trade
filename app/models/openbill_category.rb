class OpenbillCategory < ApplicationRecord
  COMPANIES_NAME = 'Организации'
  LOCKED_NAME = 'Счета блокировки'
  SYSTEM_NAME = 'Системные счета'

  has_many :openbill_accounts, foreign_key: :category_id

  def self.system
    OpenbillCategory.find_or_create_by name: SYSTEM_NAME
  end

  def self.locked
    OpenbillCategory.find_or_create_by name: LOCKED_NAME
  end

  def self.companies
    OpenbillCategory.find_or_create_by name: COMPANIES_NAME
  end
end
