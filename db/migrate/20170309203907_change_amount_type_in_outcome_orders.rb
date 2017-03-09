class ChangeAmountTypeInOutcomeOrders < ActiveRecord::Migration[5.0]
  def change
    remove_column :outcome_orders, :amount
    add_column :outcome_orders, :amount_cents, :integer, null: false
    add_column :outcome_orders, :amount_currency, :string, null: false, default: 'RUB'
  end
end
