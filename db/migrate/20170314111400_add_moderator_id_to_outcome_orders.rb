class AddModeratorIdToOutcomeOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :outcome_orders, :moderator, foreign_key: { to_table: :users }
  end
end
