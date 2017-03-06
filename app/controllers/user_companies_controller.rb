class UserCompaniesController < ApplicationController
  layout 'profile'

  def index
    require_login
    render locals: { companies: current_user.companies.ordered }
  end

  def income
    render locals: { company: company }
  end

  def outcome
    render locals: { company: company }
  end

  private

  def company
    Company.find params[:id]
  end
end
