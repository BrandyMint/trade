class CreatePassportImages < ActiveRecord::Migration[5.0]
  def change
    create_table :passport_images do |t|
      t.references :user, foreign_key: true
      t.string :image, null: false

      t.timestamps
    end
  end
end
