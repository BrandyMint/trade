module CompaniesHelper
  COMPANY_STATES_CLASSES = {
    'draft' => 'badge-info',
    'waits_review' => 'badge-warning',
    'accepted' => 'badge-success',
    'rejected' => 'badge-defaulg'
  }

  def company_icon(company)
    fa_icon :briefcase
  end

  def company_management(company)
    "#{company.management_name} (#{company.management_post})"
  end

  def company_state_tag(company)
    content_tag :span, company.state_text, class: "badge #{COMPANY_STATES_CLASSES[company.state]}"
  end

  def company_reg_info(company)
    content_tag :span, "#{company.inn} / #{company.ogrn}"
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
