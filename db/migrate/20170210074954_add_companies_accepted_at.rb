class AddCompaniesAcceptedAt < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :awaiting_review_at, :timestamp
    add_column :companies, :being_reviewed_at, :timestamp
    add_column :companies, :accepted_at, :timestamp
    add_column :companies, :rejected_at, :timestamp
    add_column :companies, :moderator_id, :integer

    add_foreign_key :companies, :users, column: :moderator_id
  end
end
