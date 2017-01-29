class AddInnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :inn, :string
  end
end
