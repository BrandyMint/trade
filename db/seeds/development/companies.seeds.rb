after 'development:users' do
  User.find_each do |user|
    3.times do
      is_legal = Random.rand(2) == 1
      user.companies.create!(
        name: Faker::Company.name,
        form: is_legal ? 'LEGAL' : 'INDIVIDUAL',
        inn: Faker::Russian.inn,
        ogrn: '1162130066526', #Faker::Russian.inn(sequence_number: 1), #Faker::Russian.ogrn,
        kpp: is_legal ? Faker::Russian.kpp : nil,
        phone: Faker::PhoneNumber.cell_phone,
        # Vydumschik::Address.street_address
        address: Faker::Address.city + ' ' + Faker::Address.street_address + ' ' + Faker::Address.secondary_address
      )
    end
  end
end
