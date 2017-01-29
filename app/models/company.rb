class Company < ApplicationRecord
  attribute :form, :string, default: 'legal'

  belongs_to :user

  validates :inn, presence: true, uniqueness: true
  validates :name, presence: true
  validates :form, presence: true, inclusion: %w(legal individual)

  def legal?
    form == 'legal'
  end

  def individual?
    form == 'individual'
  end
end
