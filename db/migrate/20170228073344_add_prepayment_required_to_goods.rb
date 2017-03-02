class AddPrepaymentRequiredToGoods < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :prepayment_required, :boolean, null: false, default: true
  end
end
