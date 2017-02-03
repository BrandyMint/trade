ActiveAdmin.register Company do
  scope :waits_review
  scope :rejected
  scope :accepted
  scope :draft
  scope :all

  index do
    column :id
    column :state_text, sortable: :state do |company|
      status_tag company.state_text
    end
    column :name
    column :inn
    column :ogrn
    column :form
    column :phone
    column :management_name
    column :documents_count
    column :amount, sortable: 'openbill_accounts.amount_cents'
    column :user
    actions
  end

  controller do
    def scoped_collection
      super.includes :user, :account
    end
  end

  show do
    h3 company.name
    attributes_table do
       row :id
       row :amount
    end
    panel 'Документы' do
      table_for company.documents do
        column :file do |document|
          link_to document.file.url do
            image_tag document.file.thumb.url
          end
        end
        column :file_size do |document|
          #document.file.image?
          number_to_human_size document.file.size
        end
      end
    end

    active_admin_comments
  end

  sidebar "Владелец", only: [:show, :edit] do
    attributes_table_for company.user do
      row :id
      row :name
      row :email
      row :phone
    end

  end

  #action_item :accept, only: [:show, :edit] do
  #link_to "Одобрить", "/"
  #end

  #action_item :reject, only: [:show, :edit] do
  #link_to "Отклонить", "/"
  #end

  permit_params Company.attribute_names
end
