class Order < ApplicationRecord
  belongs_to :user
  belongs_to :company
  belongs_to :good

  delegate :amount, to: :good
end
