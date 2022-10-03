class PolygonSearchService
  def initialize
    @property = []
    @user_prefernce = []
    @properties = []
  end

  def search_property(polygon)
    cordinates_array = eval(polygon)
    cordinates_array.each do |record|
      res =  LocationFinderService.get_location_attributes_by_reverse([record[:latitude],record[:longitude]])
      _property_list = Property.where("address ILIKE (?) OR (address ILIKE (?) AND address ILIKE (?))",
                                      "%#{res[:full_address]}%", "%#{res[:country]}%", "%#{res[:city]}%")
      if _property_list.present?
        _property_list.each do |property|
          property.weight_age = "100"
          @property << property
        end
      else
        @property = []
      end
    end
    return @property
  end

  def search_user(polygon)
    array = eval(polygon)
    array.each do |address|
      res = LocationFinderService.get_location_attributes_by_reverse([address[:latitude], address[:longitude]])
      property = Property.find_by("address ILIKE ? AND address ILIKE ? AND address ILIKE ?", "%#{res[:house_number]}%", "%#{res[:city]}%", "%#{res[:country]}%")
      unless property == nil
        @properties << property
      end
    end
    user_prefernce = UserPreference.where(user_id: @properties.pluck(:user_id).uniq)
    user_prefernce.each do |user_preference|
      user_prefernce.weight_age = "100"
      @user_prefernce << user_prefernce
    end
    @user_prefernce = @user_prefernce.flatten
  end

  def dream_address_user
    DreamAddress.all.each do |dream_address|
      res = LocationFinderService.get_location_attributes_by_reverse([dream_address.latitude, dream_address.longitude])
      property = Property.find_by("(city ILIKE ? AND country ILIKE ?) OR (address ILIKE ?)", "%#{res[:city]}%", "%#{res[:country]}%", "%#{res[:address]}%")
      unless property == nil
        @properties << property
      end
    end
    user_prefernce = UserPreference.where(user_id: @properties.pluck(:user_id).uniq)
    user_prefernce.each do |user_preference|
      user_prefernce.weight_age = "100"
      @user_prefernce << user_prefernce
    end
    @user_prefernce = @user_prefernce.flatten
  end
end