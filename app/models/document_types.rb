DocumentTypesUstav = 'ustav'
DocumentTypesReshenie = 'reshenie'
DocumentTypesPrikaz = 'prikaz'
DocumentTypes = [
  OpenStruct.new(title: 'Устав', key: DocumentTypesUstav),
  OpenStruct.new(title: 'Решение о назначении руководителя', key: DocumentTypesReshenie),
  OpenStruct.new(title: 'Приказ о назначении руководителя', key: DocumentTypesPrikaz),
]
