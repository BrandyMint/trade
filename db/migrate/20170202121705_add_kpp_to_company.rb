class AddKppToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :kpp, :string
    add_column :companies, :short_name, :string
    add_column :companies, :management_post, :string
    add_column :companies, :management_name, :string
    add_column :companies, :address, :string
  end
end
