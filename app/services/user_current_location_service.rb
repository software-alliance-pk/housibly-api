class UserCurrentLocationService
  def call(location)
    res = location
    cordinates = res.data["loc"]&.split(",")
    location = LocationFinderService.get_location_attributes_by_reverse(cordinates)
    return location
  end
end