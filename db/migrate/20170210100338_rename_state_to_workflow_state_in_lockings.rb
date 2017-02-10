class RenameStateToWorkflowStateInLockings < ActiveRecord::Migration[5.0]
  def change
    rename_column :openbill_lockings, :state, :workflow_state
  end
end
