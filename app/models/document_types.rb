DocumentTypesUstav = 'ustav'
DocumentTypesReshenie = 'reshenie'
DocumentTypesPrikaz = 'prikaz'
DocumentTypesInn = 'inn'
DocumentTypesPassport = 'passport'
DocumentTypesOgrn = 'ogrn'
DocumentTypes = [
  OpenStruct.new(title: 'Устав', key: DocumentTypesUstav),
  OpenStruct.new(title: 'Решение о назначении руководителя', key: DocumentTypesReshenie),
  OpenStruct.new(title: 'Приказ о назначении руководителя', key: DocumentTypesPrikaz),
  OpenStruct.new(title: 'ИНН', key: DocumentTypesInn),
  OpenStruct.new(title: 'ОГРН', key: DocumentTypesOgrn),
  OpenStruct.new(title: 'Паспорт руководителя', key: DocumentTypesPassport)
]
