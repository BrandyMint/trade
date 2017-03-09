class RenamePulichatelToPoluchatel < ActiveRecord::Migration[5.0]
  def change
    rename_column :requisites, :pulichatel, :poluchatel
  end
end
