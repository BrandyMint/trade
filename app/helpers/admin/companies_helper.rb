module Admin::CompaniesHelper
  def admin_company_link(company)
    link_to admin_company_path(company) do
      company_icon company, company.name
    end
  end
end
