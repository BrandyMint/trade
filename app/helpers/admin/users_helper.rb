module Admin::UsersHelper
  def login_as_link(user)
    link_to 'Войти под пользователем', supersignin_path(user), class: 'btn btn-outline-danger btn-sm'
  end
end
