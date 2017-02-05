class AddFileSizeToCompanyDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :company_documents, :file_size, :bigint
    add_column :company_documents, :content_type, :string
  end
end
