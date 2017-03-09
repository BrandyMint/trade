class RemoveAmountFromRequisites < ActiveRecord::Migration[5.0]
  def change
    remove_column :requisites, :amount
  end
end
