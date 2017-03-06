class AdminUsersSearchForm
  include ActiveModel::Model
  include ActiveModel::Serialization

  ATTRS = %w{name_or_email_or_phone_cont}

  attr_accessor *ATTRS

  def empty?
    serializable_hash.values.map(&:presence).compact.empty?
  end

  def attributes
    ATTRS.inject({}) { |a,b| a[b]=1; a }
  end
end
