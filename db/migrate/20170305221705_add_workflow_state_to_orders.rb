class AddWorkflowStateToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :workflow_state, :string, null: false, default: :actual
  end
end
