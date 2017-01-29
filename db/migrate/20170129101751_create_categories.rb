class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :title, null: false
      t.integer :parent_id

      t.timestamps
    end

    add_foreign_key :categories, :categories, column: :parent_id

    add_index :categories, [:parent_id, :title], unique: true
  end
end
