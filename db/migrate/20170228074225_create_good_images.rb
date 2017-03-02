class CreateGoodImages < ActiveRecord::Migration[5.0]
  def up
    create_table :good_images do |t|
      t.references :good, foreign_key: true, null: false
      t.string :image, null: false
      t.bigint :file_size, null: false
      t.string :content_type, null: false
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end

  def down
    drop_table :good_images
  end
end
