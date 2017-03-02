module GoodsScope
  def goods_scope
    Good.published
  end

  def goods_index
    scope = goods_scope.includes(:company, :category).view_order

    scope = scope.where(company_id: params[:company_id]) if params[:company_id].present?
    scope = scope.where(category_id: params[:category_id]) if params[:category_id].present?

    scope = scope.search_by_title search_form.q if search_form.q.present?

    scope.page params[:page]
  end
end
