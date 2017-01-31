# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
OpenbillCategory.create name: 'Организации'

category = Category.create(title: 'Категория')
user = User.create(email: 'test@brandymint.ru', password: '123', password_confirmation: '123')
company = user.create_company! name: 'Рога и Копыта', inn: '123123', ogrn: '123456'

company.goods.create title: 'Компьютер', price: 100000, category: category, remote_image_url: 'http://geniuspc.ru/wp-content/uploads/2015/01/сам-вкл3.png'
company.goods.create title: 'Плазморез', price: 2000000, category: category, remote_image_url: 'http://static.baza.farpost.ru/v/1378166635106_bulletin'
company.goods.create title: 'Автомобиль', price: 2000000, category: category, remote_image_url: 'http://www.svadba-inform.ru/userfiles/foto_molodozh/cortezh/Lexus_GS.jpg'
