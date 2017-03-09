users_count = 10

if User.count < users_count
  User.create!(email: 'admin@brandymint.ru', password: '123', password_confirmation: '123', name: 'Danil Pismenny (admin)', role: 'superadmin', phone: '+79033891227')
  User.create!(email: 'manager@brandymint.ru', password: '123', password_confirmation: '123', name: 'Danil Pismenny (manager)', role: 'manager', phone: '+79033891226')
  User.create!(email: 'danil@brandymint.ru', password: '123', password_confirmation: '123', name: 'Danil Pismenny (user)', role: 'user', phone: '+79033891228')

  users_count.times do |user|
    User.create!(email: Faker::Internet.email , password: '123', password_confirmation: '123', name: Vydumschik::Name.full_name, phone: Faker::PhoneNumber.cell_phone)
  end
end
