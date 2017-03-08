module BreadcrumbsHelper
  def admin_companies_breadcrumbs(company)
    current_breadcrumbs = [
      { title: 'Оганизации', url: admin_companies_path },
      { title: "#{company_icon(company)} #{company} [##{company.id}] #{company_state_tag(company)}".html_safe, active: true }
    ]
    render 'breadcrumbs', breadcrumbs: current_breadcrumbs
  end

  def user_goods_breadcrumbs(good)
    good_title = good.persisted? ? good : 'Новое торговое предложение'
    current_breadcrumbs = [
      { title: 'Мои предложения', url: user_goods_path },
      { title: good_title, active: true }
    ]
    render 'breadcrumbs', breadcrumbs: current_breadcrumbs
  end
end
