class AddUniqueIndexToPhones < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :phone, unique: true
  end
end
