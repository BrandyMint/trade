module CompaniesHelper
  def company_icon(company)
    fa_icon :briefcase
  end

  def company_form_collection
    [
      ['Юридическое лицо', 'LEGAL'],
      ['Индивидуальный предприниматель', 'INDIVIDUAL']
    ]
  end

  def humanized_form(form)
    I18n.t form, scope: [:helpers, :company_forms]
  end
end
