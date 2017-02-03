module GoodsHelper
  def company_goods_count(company)
    if company.goods_count > 0
      link_to "#{company.goods_count} поз.", goods_path(company_id: company.id)
    else
      content_tag :span, 'нет предложений', class: 'text-muted'
    end
  end
  def good_details(good)
    content_tag :span, class: 'text-muted' do
      good.details || 'нет описания'
    end
  end
end
