class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless Phoner::Phone.valid? value
      msg = options[:message] || I18n.t('validators.phone_validator.invalid_phone')
      record.errors.add attribute, msg
    end
  end
end
