class PolygonSearchService
  def initialize
    @property = []
    @user_prefernce = []
    @properties = []
  end

  def search_property(polygon)
    # old logic
    # cordinates_array = eval(polygon)
    # cordinates_array.each do |record|
    #   res =  LocationFinderService.get_location_attributes_by_reverse([record[:latitude],record[:longitude]])
    #   _property_list = Property.where("address ILIKE (?) OR (address ILIKE (?) AND address ILIKE (?))",
    #                                   "%#{res[:full_address]}%", "%#{res[:country]}%", "%#{res[:city]}%")
    #   if _property_list.present?
    #     _property_list.each do |property|
    #       property.weight_age = "100"
    #       @property << property
    #     end
    #   else
    #     @property = []
    #   end
    # end
    # return @property

    # new logic
    cordinates_array = eval(polygon)
    if cordinates_array.present?
      latitudes = cordinates_array.map { |location| location[:latitude] }
      longitudes = cordinates_array.map { |location| location[:longitude] }
      max_lat = latitudes.max
      min_lat = latitudes.min
      max_long = longitudes.max
      min_long = longitudes.min

      sw_corner = [min_lat, min_long]
      ne_corner = [max_lat, max_long]
      _property_list = Property.in_bounds([sw_corner, ne_corner])

      # debugger
      # _property_list = []
      # coordinates.each do |point|
      #   objects = Property.near(point, 1, units: :km)
      #   _property_list.concat(objects)
      # end

      if _property_list.present?
        _property_list.each do |property|
          property.weight_age = "100"
          @property << property
        end
      else
        @property = []
      end
      return @property
    end
  end

  def search_user(polygon)
    array = eval(polygon)
    array.each do |address|
      # res = LocationFinderService.get_location_attributes_by_reverse([address[:latitude], address[:longitude]])
      # property = Property.find_by("address ILIKE ? AND address ILIKE ? AND address ILIKE ?", "%#{res[:house_number]}%", "%#{res[:city]}%", "%#{res[:country]}%")

      latitude = address[:latitude]
      longitude = address[:longitude]
      @properties = Property.where(latitude: latitude, longitude: longitude)
      # @properties = Property.near([latitude, longitude], 1, units: :km)

      # unless property == nil
      #   @properties << property
      # end
    end
    # @properties = Property.where(id: @properties.map(&:id))
    user_prefernce = UserPreference.where(user_id: @properties.reorder('').pluck(:user_id).uniq)
    user_prefernce.each do |user_preference|
      user_prefernce.weight_age = "100"
      @user_prefernce << user_prefernce
    end
    @user_prefernce = @user_prefernce.flatten
  end

  def dream_address_user
    DreamAddress.all.each do |dream_address|
      # res = LocationFinderService.get_location_attributes_by_reverse([dream_address.latitude, dream_address.longitude])
      # property = Property.find_by("(city ILIKE ? AND country ILIKE ?) OR (address ILIKE ?)", "%#{res[:city]}%", "%#{res[:country]}%", "%#{res[:address]}%")

      @properties = Property.where(latitude: dream_address.latitude, longitude: dream_address.longitude)
      # @properties = Property.near([dream_address.latitude, dream_address.longitude], 1, units: :km)

      # unless property == nil
      #   @properties << property
      # end
    end
    user_prefernce = UserPreference.where(user_id: @properties.reorder('').pluck(:user_id).uniq)
    user_prefernce.each do |user_preference|
      user_prefernce.weight_age = "100"
      @user_prefernce << user_prefernce
    end
    @user_prefernce = @user_prefernce.flatten
  end
end
