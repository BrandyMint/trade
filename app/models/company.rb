class Company < ApplicationRecord
  FORMS = %w(LEGAL INDIVIDUAL)

  include PgSearch
  extend Enumerize
  include RegistrationSteps
  include CompanyModerationWorkflow

  # Не сохраняемый атрибут используется в форме для dadata suggestions
  #
  attr_accessor :party

  attribute :form, :string, default: 'LEGAL'

  scope :ordered, -> { order 'id desc' }
  pg_search_scope :search_by_name,
    against: { name: 'A', management_name: 'B', inn: 'B', ogrn: 'B', kpp: 'B', email: 'A', phone: 'A', management_post: 'C', address: 'D' },
    using: { tsearch: { negation: true, dictionary: 'russian', prefix: true } }


  belongs_to :user
  belongs_to :account, class_name: 'OpenbillAccount'
  belongs_to :moderator, class_name: 'User'

  has_many :goods
  has_many :documents, class_name: 'CompanyDocument'

  has_many :buyer_lockings, class_name: 'OpenbillLocking', inverse_of: :buyer, foreign_key: :buyer_id
  has_many :seller_lockings, class_name: 'OpenbillLocking', inverse_of: :seller, foreign_key: :seller_id

  validates :form, presence: true, inclusion: FORMS
  validates :name, presence: true

  validates :inn, presence: true, inn_format: true, uniqueness: { scope: :user_id }
  validates :ogrn, presence: true, ogrn_format: true
  validates :kpp, presence: true, kpp_format: true, if: :legal?

  validates :email, presence: true, email: true
  validates :phone, presence: true, phone: true

  before_create :create_account

  enumerize :form,
    in: FORMS,
    predicates: true,
    scope: true,
    default: FORMS.first

  delegate :amount, to: :account

  def awaiting_review!
  end

  def inn_kpp
    [inn, kpp].compact.join(' / ')
  end

  def locked_amount
    Money.new buyer_lockings.with_locked_state.sum(:amount_cents)
  end

  def document_categories
    DocumentTypes.map(&:key)
  end

  def all_documents_loaded?
    return false unless persisted?
    documents.group(:category).count.keys.sort == document_categories.sort
  end

  def legal?
    form == 'LEGAL'
  end

  def individual?
    form == 'INDIVIDUAL'
  end

  def to_s
    name
  end

  private

  def create_account
    self.account ||= OpenbillAccount.create! category: OpenbillCategory.companies
  end
end
