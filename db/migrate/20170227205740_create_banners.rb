class CreateBanners < ActiveRecord::Migration[5.0]
  def change
    create_table :banners do |t|
      t.string :subject, null: false
      t.text :text
      t.boolean :is_active, null: false, default: false

      t.timestamps
    end
  end
end
