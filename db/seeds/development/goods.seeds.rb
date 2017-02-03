images = [
  'http://www.bel-traktor.ru/photos/med/426_2.jpg',
  'https://delovoymir.biz/res/images/uploaded/columns/2832.jpg',
  'http://ipopen.ru/wp-content/uploads/2015/06/Эльдорадо_комплект.jpg',
  'http://remont-plys.ru/wp-content/uploads/2015/05/Vidy-metalloobrabatyvayushhix-stankov.jpg',
  'http://kvedomosti.ru/wp-content/uploads/2016/11/don500.jpg'
]

after :categories, 'development:companies' do
  categories = Category.all
  Company.find_each do |company|
    3.times do
      company.goods.create!(
        title: Vydumschik::Lorem.word,
        price: Random.rand(10000)*1000, category: categories.sample,
        details: Vydumschik::Lorem.sentence,
        remote_image_url: images.sample
      )
    end
  end
end
