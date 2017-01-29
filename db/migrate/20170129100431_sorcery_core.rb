class SorceryCore < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email,            :null => false
      t.string :phone
      t.string :crypted_password
      t.string :salt

      t.timestamps                :null => false
    end

    add_index :users, :email, unique: true
    add_index :users, :phone, unique: true
  end
end
