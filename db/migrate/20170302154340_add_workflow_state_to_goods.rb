class AddWorkflowStateToGoods < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :workflow_state, :string, null: false, default: 'draft'
  end
end
