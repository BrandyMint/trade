module Admin::UsersHelper
  def login_as_link(user, title = 'Войти под пользователем')
    link_to title, supersignin_path(user_id: user.id), class: 'btn btn-outline-danger btn-sm', method: :post
  end
end
