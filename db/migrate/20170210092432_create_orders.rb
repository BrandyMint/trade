class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true, null: false
      t.references :company, foreign_key: true, null: false
      t.references :good, foreign_key: true, null: false

      t.timestamps
    end
  end
end
