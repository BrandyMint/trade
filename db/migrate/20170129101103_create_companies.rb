class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.references :user, null: false
      t.string :form, null: false, default: 'company'
      t.string :name, null: false
      t.string :ogrn, null: false
      t.string :inn, null: false
      t.string :kpp, null: true

      t.timestamps
    end

    add_index :companies, [:user_id, :inn], unique: true
  end
end
