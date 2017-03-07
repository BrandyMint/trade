class CompanyMailer < ApplicationMailer
  def accepted_email(company)
    @company = company
    @url = user_goods_url
    action_mail company.user
  end

  def rejected_email(company)
    @company = company
    @url = edit_company_url @company
    action_mail company.user
  end
end
