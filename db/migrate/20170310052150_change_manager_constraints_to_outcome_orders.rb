class ChangeManagerConstraintsToOutcomeOrders < ActiveRecord::Migration[5.0]
  def change
    change_column :outcome_orders, :manager_id, :integer, null: true
  end
end
