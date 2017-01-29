class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :form
      t.string :inn
      t.string :ogrn
      t.string :charter
      t.string :order
      t.string :decision

      t.timestamps
    end
  end
end
