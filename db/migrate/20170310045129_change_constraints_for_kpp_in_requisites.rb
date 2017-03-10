class ChangeConstraintsForKppInRequisites < ActiveRecord::Migration[5.0]
  def change
    change_column :requisites, :kpp, :string, null: true
  end
end
