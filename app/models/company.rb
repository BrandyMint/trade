class Company < ApplicationRecord
  extend Enumerize

  attribute :form, :string, default: 'legal'

  belongs_to :user
  belongs_to :account, class_name: 'OpenbillAccount'

  has_many :goods

  validates :form, presence: true, inclusion: %w(legal individual)
  validates :name, presence: true

  validates :inn, presence: true, inn_format: true, uniqueness: { scope: :user_id }
  validates :ogrn, presence: true, ogrn_format: true
  validates :kpp, presence: true, kpp_format: true

  before_create :create_account

  enumerize :state,
    in: %w(draft waits_review accepted rejected),
    predicates: true,
    default: 'draft'

  def legal?
    form == 'legal'
  end

  def to_s
    name
  end

  def individual?
    form == 'individual'
  end

  def moderated?
  end

  private

  def create_account
    self.account ||= OpenbillAccount.create category: OpenbillSettings.company_category
  end
end
