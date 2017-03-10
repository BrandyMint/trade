class AddKsNumberToRequisites < ActiveRecord::Migration[5.0]
  def change
    add_column :requisites, :ks_number, :string
  end
end
