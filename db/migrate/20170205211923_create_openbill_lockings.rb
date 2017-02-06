class CreateOpenbillLockings < ActiveRecord::Migration[5.0]
  def change
    create_table :openbill_lockings do |t|
      t.references :seller, null: false
      t.references :buyer, null: false
      t.references :good, null: false
      t.uuid :locking_transaction_id, null: false
      t.uuid :reverse_transaction_id
      t.uuid :buy_transaction_id
      t.string :state, null: false
      t.decimal  "amount_cents",                 null: false
      t.string   "amount_currency",    limit: 3, default: "RUB",          null: false

      t.timestamps
    end

    add_foreign_key :openbill_lockings, :companies, column: :seller_id
    add_foreign_key :openbill_lockings, :companies, column: :buyer_id
    add_foreign_key :openbill_lockings, :goods
    add_foreign_key :openbill_lockings, :openbill_transactions, column: :locking_transaction_id
    add_foreign_key :openbill_lockings, :openbill_transactions, column: :reverse_transaction_id
    add_foreign_key :openbill_lockings, :openbill_transactions, column: :buy_transaction_id

    add_index :openbill_lockings, :state
    add_index :openbill_lockings, :locking_transaction_id
    add_index :openbill_lockings, :reverse_transaction_id
    add_index :openbill_lockings, :buy_transaction_id
  end
end
