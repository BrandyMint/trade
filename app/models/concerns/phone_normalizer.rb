module PhoneNormalizer
  def normalize_phone(phone)
    return if phone.blank?
    if phone.length == '11'
      if phone[0] == '7'
        phone = '+' + phone
      elsif phone[0] == '8'
        phone = '+7' + phone.slice(1, 11)
      end
    end

    unless phone[0] == '+'
      if Phoner::Phone.parse(phone).blank? && Phoner::Phone.parse('+' + phone).to_s.present?
        phone = '+' + phone
      end
    end
    Phoner::Phone.parse(phone).to_s
  rescue Phoner::CountryCodeError
    ''
  end
end
