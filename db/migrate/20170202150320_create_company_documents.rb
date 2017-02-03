class CreateCompanyDocuments < ActiveRecord::Migration[5.0]
  def change
    remove_column :companies, :charter
    remove_column :companies, :decision
    remove_column :companies, :order

    create_table :company_documents do |t|
      t.references :company, null: false
      t.string :file, null: false
      t.string :state, null: false

      t.timestamps
    end
  end
end
