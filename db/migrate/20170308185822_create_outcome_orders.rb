class CreateOutcomeOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :outcome_orders do |t|
      t.references :user, foreign_key: true, null: false
      t.references :company, foreign_key: true, null: false
      t.decimal :amount, null: false
      t.string :workflow_state, null: false
      t.references :manager, foreign_key: { to_table: :users }, null: false
      t.uuid :transaction_uuid
      t.references :requisite, foreign_key: true, null: false
      t.string :reject_message

      t.timestamps
    end

    add_foreign_key :outcome_orders, :openbill_transactions, primary_key: :id, column: :transaction_uuid
  end
end
