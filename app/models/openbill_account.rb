class OpenbillAccount < OpenbillRecord
  belongs_to :category, class_name: 'OpenbillCategory'
end
