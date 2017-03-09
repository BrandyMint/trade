class ChangeTypeDetailsInRequisites < ActiveRecord::Migration[5.0]
  def change
    change_column :requisites, :details, :text
  end
end
