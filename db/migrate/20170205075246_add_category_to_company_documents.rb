class AddCategoryToCompanyDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :company_documents, :category, :string

    change_column :company_documents, :category, :string, null: false

    add_index :company_documents, [:company_id, :category]
  end
end
