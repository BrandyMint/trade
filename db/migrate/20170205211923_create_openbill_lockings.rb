class CreateOpenbillLockings < ActiveRecord::Migration[5.0]
  def change
    create_table :openbill_lockings do |t|
      t.references :seller_account, null: false
      t.references :buyer_account, null: false
      t.decimal  "amount_cents",                 null: false
      t.string   "amount_currency",    limit: 3, default: "RUB",          null: false
      t.references :transaction, null: false

      t.timestamps
    end
  end
end
