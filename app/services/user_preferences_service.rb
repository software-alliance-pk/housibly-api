class UserPreferencesService

  def initialize
    @property = []
  end

  def search_property(user)
    _weight_age = 0
    user_preference =  user.user_preference

    property_type_records = Property.property_type_matcher(user_preference.property_types)
    _weight_age = _weight_age + 10  if property_type_records.present?

    price_records  = Property.price_matcher(user_preference.min_price,user_preference.max_price)
    _weight_age = _weight_age + 7.5  if  price_records.present?

    bath_rooms_records = Property.bath_rooms_matcher(user_preference.min_bathrooms,user_preference.max_bathrooms)
    _weight_age = _weight_age + 7.5  if bath_rooms_records.present?


    bed_rooms_records = Property.bed_rooms_matcher(user_preference.min_bedrooms,user_preference.max_bedrooms)
    _weight_age = _weight_age + 7.5 if bed_rooms_records.present?

    parking_spot_records = Property.property_parking_spot(user_preference.parking_spot,user_preference.parking_spot)
    _weight_age = _weight_age + 7.5 if parking_spot_records.present?

    garbage_spot_records = Property.property_garage(user_preference.garbage_spot)
    _weight_age = _weight_age + 7.5 if garbage_spot_records.present?


    security_records = Property.property_security(user_preference.security)
    _weight_age = _weight_age + 7.5 if security_records.present?

    min_lot_frontage_records = Property.property_min_lot_frontage(user_preference.min_lot_frontage)
    _weight_age = _weight_age + 7.5 if min_lot_frontage_records.present?

    min_lot_size_records = Property.property_min_lot_size(user_preference.min_lot_size,user_preference.max_lot_size)
    _weight_age = _weight_age + 7.5 if min_lot_frontage_records.present?


    # living_space_records = Property.property_living_space(user_preference.min_living_space,user_preference.max_living_space)
    # _value = calculate_weightage(_weight_age,living_space_records,7)
    # _weight_age = _value if _value.present?


    style_records = Property.property_style_matcher(user_preference.property_style)
    _weight_age = _weight_age + 7.5 if style_records.present?

    number_records = Property.property_total_number_of_rooms(user_preference.min_living_space,user_preference.max_living_space)
    _weight_age = _weight_age + 7.5 if number_records.present?

    age_records = Property.property_age(user_preference.max_age)
    _weight_age = _weight_age + 7.5 if age_records.present?

    type_records = Property.property_type_matcher_2(user_preference.property_type)
    _weight_age = _weight_age + 7.5 if type_records.present?

    #living_space_records
    @property_list = (property_type_records  + price_records + bed_rooms_records + type_records +
      parking_spot_records + garbage_spot_records + security_records + min_lot_frontage_records +
      min_lot_size_records + style_records + number_records + age_records )&.uniq
    @property_list.each do |record|
      record.weight_age = _weight_age
      @property << record
    end
    return @property
  end
end