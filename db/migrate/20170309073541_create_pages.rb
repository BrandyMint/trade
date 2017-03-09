class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.string :title, null: false
      t.integer :row_order, null: false
      t.boolean :is_active, null: false, default: false
      t.text :text, null: false
      t.string :slug, null: false

      t.timestamps
    end

    add_index :pages, :slug, unique: true
    add_index :pages, :row_order
  end
end
