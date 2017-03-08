class UserGoodsSearchForm
  include ActiveModel::Model
  include ActiveModel::Serialization

  ATTRS = %w{title_cont company_id_eq workflow_state_eq category_id_eq prepayment_required_eq}

  attr_accessor(*ATTRS)

  def category
    Category.find category_id_eq if category_id_eq.present?
  end

  def empty?
    serializable_hash.values.map(&:presence).compact.empty?
  end

  def attributes
    ATTRS.inject({}) { |a,b| a[b]=1; a }
  end
end
