class ChangeContraintCompanyDocuments < ActiveRecord::Migration[5.0]
  def change
    change_column :company_documents, :file_size, :bigint, null: false
    change_column :company_documents, :content_type, :varchar, null: false
  end
end
