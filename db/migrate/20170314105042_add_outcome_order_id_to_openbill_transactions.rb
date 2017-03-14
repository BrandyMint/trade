class AddOutcomeOrderIdToOpenbillTransactions < ActiveRecord::Migration[5.0]
  def change
    add_reference :openbill_transactions, :outcome_order, foreign_key: true
  end
end
