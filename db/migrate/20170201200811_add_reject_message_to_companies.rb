class AddRejectMessageToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :reject_message, :text
  end
end
