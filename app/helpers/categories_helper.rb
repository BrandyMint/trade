module CategoriesHelper
  def categories_collection
    Category.ordered
  end
end
