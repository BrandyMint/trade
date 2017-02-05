class AddLockedAccountToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :locked_account_id, :uuid
    Company.find_each do |c|
      c.send :create_locked_account
      c.save!
    end
  end
end
