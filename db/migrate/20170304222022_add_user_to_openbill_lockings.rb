class AddUserToOpenbillLockings < ActiveRecord::Migration[5.0]
  def change
    add_reference :openbill_lockings, :user, foreign_key: true, null: false
  end
end
