class SearchForm
  include ActiveModel::Model
  attr_accessor :q

  validates :q, presence: true
end
