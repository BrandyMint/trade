class AddStateToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :state, :string
  end
end
