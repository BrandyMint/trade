class UserCompaniesController < ApplicationController
  layout 'profile'

  def index
    render locals: { companies: current_user.companies.ordered }
  end
end
