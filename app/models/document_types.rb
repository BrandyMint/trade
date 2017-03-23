DocumentTypesUstav = 'ustav'
DocumentTypesReshenie = 'reshenie'
DocumentTypesPrikaz = 'prikaz'
DocumentTypesInn = 'inn'
DocumentTypesPassport = 'passport'
DocumentTypesOgrn = 'ogrn'
DocumentTypesOgrnip = 'ogrnip'

module DocumentTypes

  Legal = [
    OpenStruct.new(title: 'Устав', key: DocumentTypesUstav),
    OpenStruct.new(title: 'Решение о назначении руководителя', key: DocumentTypesReshenie),
    OpenStruct.new(title: 'Приказ о назначении руководителя', key: DocumentTypesPrikaz),
    OpenStruct.new(title: 'ИНН', key: DocumentTypesInn),
    OpenStruct.new(title: 'ОГРН', key: DocumentTypesOgrn),
    OpenStruct.new(title: 'Паспорт руководителя', key: DocumentTypesPassport, details: 'Необходимо загрузить цветную скан копию всех значимых страниц паспорта руководителя (паспорт в развороте, с вашими данными и фото, плюс страница с пропиской)')
  ]


  Individual = [
    OpenStruct.new(title: 'Паспорт', key: DocumentTypesPassport, details: 'Необходимо загрузить цветную скан копию всех значимых страниц вашего паспорта (паспорт в развороте, с вашими данными и фото, плюс страница с пропиской)'),
    OpenStruct.new(title: 'ИНН', key: DocumentTypesInn),
    OpenStruct.new(title: 'ОГРНИП', key: DocumentTypesOgrnip)
  ]

  Personal = [
    OpenStruct.new(title: 'Паспорт', key: DocumentTypesPassport)
  ]

  All = [
    DocumentTypesUstav,
    DocumentTypesReshenie,
    DocumentTypesPrikaz,
    DocumentTypesInn,
    DocumentTypesPassport,
    DocumentTypesOgrn,
    DocumentTypesOgrnip
  ]

end
