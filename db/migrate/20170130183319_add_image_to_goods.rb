class AddImageToGoods < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :image, :string
  end
end
