class Company < ApplicationRecord
  attribute :form, :string, default: 'legal'

  belongs_to :user
  belongs_to :account, class_name: 'OpenbillAccount'

  has_many :goods

  validates :inn, presence: true, uniqueness: true
  validates :name, presence: true
  validates :form, presence: true, inclusion: %w(legal individual)
  validates :ogrn, presence: true, uniqueness: true

  before_create :create_account

  def legal?
    form == 'legal'
  end

  def to_s
    name
  end

  def individual?
    form == 'individual'
  end

  private

  def create_account
    self.account ||= OpenbillAccount.create category: OpenbillSettings.company_category
  end
end
