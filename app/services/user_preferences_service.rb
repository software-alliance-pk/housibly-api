class UserPreferencesService

  def initialize
    @property = []
    @user_prefernce = []
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

    # min_lot_frontage_records = Property.property_min_lot_frontage(user_preference.min_lot_frontage)
    # _weight_age = _weight_age + 7.5 if min_lot_frontage_records.present?

    # min_lot_size_records = Property.property_min_lot_size(user_preference.min_lot_size,user_preference.max_lot_size)
    # _weight_age = _weight_age + 7.5 if min_lot_frontage_records.present?


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
      parking_spot_records + garbage_spot_records + security_records + style_records + number_records + age_records )&.uniq
    @property_list.each do |record|
      record.weight_age = _weight_age
      @property << record
    end
    return @property
  end

  def search_user(property)
     _weight_age = 0
    price_records  = UserPreference.price_matcher(property.price)
    _weight_age = _weight_age + 7.5  if  price_records.present?
    
    bath_rooms_records = UserPreference.bath_rooms_matcher(property.bath_rooms)
    _weight_age = _weight_age + 7.5  if bath_rooms_records.present?
    
    bed_rooms_records = UserPreference.bed_rooms_matcher(property.bed_rooms)
    _weight_age = _weight_age + 7.5  if bed_rooms_records.present?
    
    property_type_records = UserPreference.property_type_matcher(property.type)
    _weight_age = _weight_age + 10  if property_type_records.present?
    
    # parking_spot_records = UserPreference.property_parking_spot(property.total_parking_spaces)
    # _weight_age = _weight_age + 7.5 if parking_spot_records.present?
    
    garbage_spot_records = UserPreference.property_garage(property.garage)
    _weight_age = _weight_age + 7.5 if garbage_spot_records.present?
    
    security_records = UserPreference.property_security(property.security)
    _weight_age = _weight_age + 7.5 if security_records.present?

    # min_lot_frontage_records = UserPreference.property_min_lot_frontage(property.lot_frontage)
    # _weight_age = _weight_age + 7.5 if min_lot_frontage_records.present?

    # min_lot_size_records = UserPreference.property_min_lot_size(property.lot_size)
    # _weight_age = _weight_age + 7.5 if min_lot_frontage_records.present?

    @user_preference_list = (property_type_records  + price_records + bed_rooms_records +
     bath_rooms_records + garbage_spot_records + security_records )&.uniq
    @user_preference_list.each do |record|
      record.weight_age = _weight_age
      @user_prefernce << record
    end
    return @user_prefernce

  end


  def top_search_user(property)
     _weight_age = 0
    price_records  = UserPreference.price_matcher(property.price)
    _weight_age = _weight_age + 7.5  if  price_records.present?
    
    bath_rooms_records = UserPreference.bath_rooms_matcher(property.bath_rooms)
    _weight_age = _weight_age + 7.5  if bath_rooms_records.present?
    
    bed_rooms_records = UserPreference.bed_rooms_matcher(property.bed_rooms)
    _weight_age = _weight_age + 7.5  if bed_rooms_records.present?
    
    property_type_records = UserPreference.property_type_matcher(property.type)
    _weight_age = _weight_age + 10  if property_type_records.present?
    
    # parking_spot_records = UserPreference.property_parking_spot(property.total_parking_spaces)
    # _weight_age = _weight_age + 7.5 if parking_spot_records.present?
    
    garbage_spot_records = UserPreference.property_garage(property.garage)
    _weight_age = _weight_age + 7.5 if garbage_spot_records.present?
    
    security_records = UserPreference.property_security(property.security)
    _weight_age = _weight_age + 7.5 if security_records.present?

    # min_lot_frontage_records = UserPreference.property_min_lot_frontage(property.lot_frontage)
    # _weight_age = _weight_age + 7.5 if min_lot_frontage_records.present?

    # min_lot_size_records = UserPreference.property_min_lot_size(property.lot_size)
    # _weight_age = _weight_age + 7.5 if min_lot_frontage_records.present?

    @user_preference_list = (property_type_records  + price_records + bed_rooms_records +
     bath_rooms_records + garbage_spot_records + security_records )&.uniq
    @user_preference_list.each do |record|
      record.weight_age = _weight_age
      if record.weight_age == "100"
        @user_prefernce << record
      end
    end
    return @user_prefernce

  end


  def newest_search_user(property)
    _weight_age = 0
    user_preference = UserPreference.joins(:user).where("users.created_at >= ?", 1.week.ago)
    price_records  = user_preference.price_matcher(property.price)
    _weight_age = _weight_age + 7.5  if  price_records.present?
    
    bath_rooms_records = user_preference.bath_rooms_matcher(property.bath_rooms)
    _weight_age = _weight_age + 7.5  if bath_rooms_records.present?
    
    bed_rooms_records = user_preference.bed_rooms_matcher(property.bed_rooms)
    _weight_age = _weight_age + 7.5  if bed_rooms_records.present?
    
    property_type_records = user_preference.property_type_matcher(property.type)
    _weight_age = _weight_age + 10  if property_type_records.present?
    
    # parking_spot_records = UserPreference.property_parking_spot(property.total_parking_spaces)
    # _weight_age = _weight_age + 7.5 if parking_spot_records.present?
    
    garbage_spot_records = user_preference.property_garage(property.garage)
    _weight_age = _weight_age + 7.5 if garbage_spot_records.present?
    
    security_records = user_preference.property_security(property.security)
    _weight_age = _weight_age + 7.5 if security_records.present?

    # min_lot_frontage_records = UserPreference.property_min_lot_frontage(property.lot_frontage)
    # _weight_age = _weight_age + 7.5 if min_lot_frontage_records.present?

    # min_lot_size_records = UserPreference.property_min_lot_size(property.lot_size)
    # _weight_age = _weight_age + 7.5 if min_lot_frontage_records.present?

    @user_preference_list = (property_type_records  + price_records + bed_rooms_records +
     bath_rooms_records + garbage_spot_records + security_records )&.uniq
    @user_preference_list.each do |record|
      record.weight_age = _weight_age
        @user_prefernce << record
    end
    return @user_prefernce

  end


end