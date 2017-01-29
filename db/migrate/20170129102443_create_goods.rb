class CreateGoods < ActiveRecord::Migration[5.0]
  def change
    create_table :goods do |t|
      t.references :company, foreign_key: true
      t.references :category, foreign_key: true
      t.integer :state_cd, null: false, default: 0
      t.string :title, null: false
      t.text :details
      t.decimal :price

      t.timestamps
    end
  end
end
