class OpenbillAccount < OpenbillRecord
  belongs_to :category, class_name: 'OpenbillCategory'

  def amount
    Money.new amount_cents, amount_currency
  end
end
