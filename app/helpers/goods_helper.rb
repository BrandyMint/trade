module GoodsHelper
  def good_details(good)
    content_tag :span, class: 'text-muted' do
      good.details || 'нет описания'
    end
  end
end
