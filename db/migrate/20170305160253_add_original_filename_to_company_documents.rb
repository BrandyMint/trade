class AddOriginalFilenameToCompanyDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :company_documents, :original_filename, :string
  end
end
