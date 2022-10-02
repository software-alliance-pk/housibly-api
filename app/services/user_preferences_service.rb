class UserPreferencesService

  def initialize
    _weight_age = 0
    @property = []
  end

  def search_property(user)
    _weight_age = 0
    user_preference =  user.user_preference

    property_type_records = Property.property_type_matcher(user_preference.property_types)
    _value = calculate_weightage(_weight_age, property_type_records, 9)
    _weight_age = _value if _value.present?

    if property_type_records.present?
      price_records  = Property.price_matcher(user_preference.min_price,user_preference.max_price)
      _value = calculate_weightage(_weight_age, price_records, 7)
      _weight_age = _value if _value.present?

      bath_rooms_records = Property.bath_rooms_matcher(user_preference.min_bathrooms,user_preference.max_bathrooms)
      _value = calculate_weightage(_weight_age, bath_rooms_records, 7)
      _weight_age = _value if _value.present?


      bed_rooms_records = Property.bed_rooms_matcher(user_preference.min_bedrooms,user_preference.max_bedrooms)
      _value = calculate_weightage(_weight_age, bed_rooms_records, 7)
      _weight_age = _value if _value.present?

      parking_spot_records = Property.property_parking_spot(user_preference.parking_spot,user_preference.parking_spot)
      _value = calculate_weightage(_weight_age, parking_spot_records, 7)
      _weight_age = _value if _value.present?

      garbage_spot_records = Property.property_garage(user_preference.garbage_spot)
      _value = calculate_weightage(_weight_age,garbage_spot_records,7)
      _weight_age = _value if _value.present?


      security_records = Property.property_security(user_preference.security)
      _value = calculate_weightage(_weight_age,security_records,7)
      _weight_age = _value if _value.present?


      min_lot_frontage_records = Property.property_min_lot_frontage(user_preference.min_lot_frontage)
      _value = calculate_weightage(_weight_age,min_lot_frontage_records,7)
      _weight_age = _value if _value.present?

      min_lot_size_records = Property.property_min_lot_size(user_preference.min_lot_size,user_preference.max_lot_size)
      _value = calculate_weightage(_weight_age,min_lot_size_records,7)
      _weight_age = _value if _value.present?


      living_space_records = Property.property_living_space(user_preference.min_living_space,user_preference.max_living_space)
      _value = calculate_weightage(_weight_age,living_space_records,7)
      _weight_age = _value if _value.present?


      style_records = Property.property_style_matcher(user_preference.property_style)
      _value = calculate_weightage(_weight_age,style_records,7)
      _weight_age = _value if _value.present?

      number_records = Property.property_total_number_of_rooms(user_preference.max_living_space)
      _value = calculate_weightage(_weight_age,number_records ,7)
      _weight_age = _value if _value.present?

      age_records = Property.property_age(user_preference.max_age)
      _value = calculate_weightage(_weight_age,age_records,7)
      _weight_age = _value if _value.present?

      type_records = Property.property_type_matcher_2(user_preference.type)
      _value = calculate_weightage(_weight_age,type_records,7)
      _weight_age = _value if _value.present?

      @property_list = (property_type_records  + price_records + bed_rooms_records + type_records +
        parking_spot_records + garbage_spot_records + security_records + min_lot_frontage_records +
        min_lot_size_records + living_space_records + style_records + number_records + age_records )&.uniq
      @property_list.each do |record|
        record.weight_age = _weight_age
        @property << record
      end
    end
    return @property
  end

  def calculate_weightage(_weight_age, matching_item, number)
    _weight_age =   matching_item.present? ? _weight_age + number : 0
  end
end