class PolyonSearchService
  def initialize
    @property = []
  end

  def search_property(params)
    cordinates_array = eval(params[:polygon])
    cordinates_array.each do |record|
      res =  LocationFinderService.get_location_attributes_by_reverse([record[:latitude],record[:longitude]])
      _property_list = Property.where("address ILIKE (?) or country ILIKE (?) AND city ILIKE (?)",
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

  def search_user

  end
end
