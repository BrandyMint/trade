module OpenbillSettings
  def self.company_category
    OpenbillCategory.find_or_create_by(name: 'Организации')
  end
end
