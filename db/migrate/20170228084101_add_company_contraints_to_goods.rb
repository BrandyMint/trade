class AddCompanyContraintsToGoods < ActiveRecord::Migration[5.0]
  def change
    Good.where(company_id: nil).delete_all
    Good.where(category_id: nil).delete_all
    change_column :goods, :company_id, :integer, null: false
    change_column :goods, :category_id, :integer, null: false
  end
end
