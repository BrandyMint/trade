class AddOrderToOpenbillLockings < ActiveRecord::Migration[5.0]
  def up
    Order.destroy_all
    add_reference :openbill_lockings, :order, foreign_key: true, null: false
    add_column :companies, :orders_count, :integer, null: false, default: 0
    add_column :users, :orders_count, :integer, null: false, default: 0
  end

  def down
    remove_column :openbill_lockings, :order_id
  end
end
