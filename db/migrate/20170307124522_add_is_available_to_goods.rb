class AddIsAvailableToGoods < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :is_company_verified, :boolean, null: false, default: false

    Company.find_each do |c|
      c.send :update_goods
    end
  end
end
