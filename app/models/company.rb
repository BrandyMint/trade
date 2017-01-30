class Company < ApplicationRecord
  attribute :form, :string, default: 'legal'

  belongs_to :user

  has_many :goods

  validates :inn, presence: true, uniqueness: true
  validates :name, presence: true
  validates :form, presence: true, inclusion: %w(legal individual)
  validates :ogrn, presence: true, uniqueness: true

  def legal?
    form == 'legal'
  end

  def to_s
    name
  end

  def individual?
    form == 'individual'
  end
end
