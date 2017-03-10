class Requisite < ApplicationRecord
  validates :bik, presence: true, bik_format: true
  validates :inn, presence: true, inn_format: true
  validates :poluchatel, presence: true
  validates :account_number, presence: true, rs_format: true
  validates :ks_number, presence: true, ks_format: true
  validates :kpp, kpp_format: true, if: :kpp?
end
