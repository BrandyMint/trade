module GoodsScope
  protected

  def goods_scope
    Good.available
  end

  def goods_index
    goods_ransack.result(distinct: true).page(params[:page])
  end

  def search_form
    UserGoodsSearchForm.new params.fetch(:q, {}).permit!
  end

  def goods_ransack
    scope = goods_scope.includes(:company, :category).view_order

    scope = scope.ransack search_form.serializable_hash
  end
end
