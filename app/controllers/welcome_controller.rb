class WelcomeController < ApplicationController
  def index
    render locals: {
      search_form: SearchForm.new,
      goods: Good.page(params[:page])
    }
  end
end
