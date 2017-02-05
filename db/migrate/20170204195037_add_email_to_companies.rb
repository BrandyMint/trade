class AddEmailToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :email, :string
  end
end
