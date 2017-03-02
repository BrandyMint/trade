module BreadcrumbsHelper
  def admin_companies_breadcrumbs(company)
    current_breadcrumbs = [
      { title: 'Оганизации', url: admin_companies_path },
      { title: "#{company_icon(company)} #{company} [##{company.id}] #{company_state_tag(company)}", active: true }
    ]
    render 'breadcrumbs', breadcrumbs: current_breadcrumbs
  end
end
