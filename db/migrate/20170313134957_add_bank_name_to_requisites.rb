class AddBankNameToRequisites < ActiveRecord::Migration[5.0]
  def change
    add_column :requisites, :bank_name, :string
  end
end
