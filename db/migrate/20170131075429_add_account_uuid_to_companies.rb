class AddAccountUuidToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :account_id, :uuid, null: false

    add_index :companies, :account_id, unique: true
  end
end
