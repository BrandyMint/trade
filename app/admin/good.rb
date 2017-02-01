ActiveAdmin.register Good do
  menu parent: 'Торговые предложения'

  index do
    column :category, sortable: 'categories.title'
    column :company, sortable: 'companies.name'
    column :id
    column :image do |good|
      image_tag good.image.thumb.url
    end
    column :title
    column :price
    column :details
    actions
  end

  controller do
    def scoped_collection
      super.includes :company, :category
    end
  end
end
