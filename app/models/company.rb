class Company < ApplicationRecord
  FORMS = %w(LEGAL INDIVIDUAL)

  extend Enumerize
  include ModerationState
  include RegistrationSteps

  # Не сохраняемый атрибут используется в форме для dadata suggestions
  #
  attr_accessor :party

  attribute :form, :string, default: 'LEGAL'

  scope :ordered, -> { order 'id desc' }

  belongs_to :user
  belongs_to :account, class_name: 'OpenbillAccount'

  has_many :goods
  has_many :documents, class_name: 'CompanyDocument'

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

  def document_categories
    DocumentTypes.map(&:key)
  end

  def all_documents_loaded?
    CompanyDocument.group(:category).count.keys.sort == document_categories.sort
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
    self.account ||= OpenbillAccount.create category: OpenbillCategory.companies
  end
end
