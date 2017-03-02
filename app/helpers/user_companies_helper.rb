module UserCompaniesHelper
  def user_companies_collection(user)
    current_user.companies.ordered.map { |c| [c.to_s, c.id] }
  end
end
