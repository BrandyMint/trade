class AddCompaniesCountToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :companies_count, :integer, null: false, default: 0

    User.pluck(:id).each do |id|
      User.reset_counters id, :companies
    end
  end
end
