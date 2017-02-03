class AddDocumentsCountToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :documents_count, :integer, null: false, default: 0
  end
end
