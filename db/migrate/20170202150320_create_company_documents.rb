class CreateCompanyDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :company_documents do |t|
      t.references :company, null: false
      t.string :file, null: false
      t.string :state, null: false

      t.timestamps
    end
  end
end
