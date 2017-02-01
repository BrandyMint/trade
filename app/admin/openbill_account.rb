ActiveAdmin.register OpenbillAccount do
  menu parent: 'Биллинг'

  index do
    column :category, sortable: 'openbill_categories.name'
    column :company, sortable: 'companies.name'
    column :amount, sortable: :amount_cents
    column :meta
    column :details
    column :created_at
    column :updated_at
    actions
  end

  controller do
    def scoped_collection
      super.includes :company, :category # prevents N+1 queries to your database
    end
  end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


end
