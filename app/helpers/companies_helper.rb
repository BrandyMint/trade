module CompaniesHelper
  COMPANY_STATES_CLASSES = {
    'draft' => 'badge-info',
    'awaiting_review' => 'badge-warning',
    'being_reviewed' => 'badge-warning',
    'accepted' => 'badge-success',
    'rejected' => 'badge-danger'
  }

  def companies_to_buy(user)
    user.companies.with_accepted_state.includes(:account).map do |c|
      title = "#{c.name}: #{humanized_money_with_symbol(c.amount)}"
      [title, c.id]
    end
  end

  def company_icon(company)
    fa_icon :briefcase
  end

  def company_management(company)
    if company.management_name.present?
      "#{company.management_name} (#{company.management_post})"
    end
  end

  def company_all_documents_loaded_tag(company)
    if company.all_documents_loaded?
      content_tag :span, 'Документы загружены', class: 'badge badge-success'
    else
      content_tag :span, 'Документы отсутсвуют', class: 'badge badge-default'
    end
  end

  def company_state_tag(company)
    content_tag :span, company.state_text, class: "badge #{COMPANY_STATES_CLASSES[company.workflow_state]}"
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

  def new_company_step_one_title(company)
    title = '1. Сведения об организации'

    if company.persisted?
      title << " (указаны) #{check_circle true}"
    else
      title << " #{check_circle false}"
    end

    title.html_safe
  end

  def new_company_step_two_title(company)
    title = "2. Загрузка уставных документов"

    if company.all_documents_loaded?
      title << " (загружены) #{check_circle true}"
    else
      title << " #{check_circle false}"
    end

    title.html_safe
  end
end
