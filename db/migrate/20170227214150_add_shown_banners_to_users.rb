class AddShownBannersToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :shown_banners, :integer, array: true, default: [], null: false
  end
end
