module CompaniesHelper
  def humanized_form(form)
    I18n.t form, scope: [:helpers, :company_forms]
  end
end
