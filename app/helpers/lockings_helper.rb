module LockingsHelper
  def locking_workflow_state_text(state)
    t(state, scope: [:enumerize, :locking_workflow_states])
  end
end
