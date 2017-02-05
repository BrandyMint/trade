class UserCompaniesController < ApplicationController
  layout 'profile'

  def index
    require_login
    render locals: { companies: current_user.companies.ordered }
  end
end
