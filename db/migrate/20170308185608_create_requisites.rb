class CreateRequisites < ActiveRecord::Migration[5.0]
  def change
    create_table :requisites do |t|
      t.string :bik, null: false
      t.string :inn, null: false
      t.string :pulichatel, null: false
      t.string :kpp, null: false
      t.decimal :amount, null: false
      t.string :account_number
      t.string :details

      t.timestamps
    end
  end
end
