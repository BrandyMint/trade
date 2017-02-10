class RenameStateToWorkflowStateInCompanies < ActiveRecord::Migration[5.0]
  def change
    rename_column :companies, :state, :workflow_state
  end
end
