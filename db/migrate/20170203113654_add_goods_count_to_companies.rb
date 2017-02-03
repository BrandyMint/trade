class AddGoodsCountToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :goods_count, :integer, null: false, default: 0
    add_column :categories, :goods_count, :integer, null: false, default: 0
  end
end
