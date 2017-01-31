class OpenbillRecord < ActiveRecord::Base
  self.abstract_class = true
  self.primary_key = 'uuid'
end
