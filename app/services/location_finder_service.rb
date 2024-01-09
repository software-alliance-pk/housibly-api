class LocationFinderService
  Geokit::Geocoders::GoogleGeocoder.api_key = ENV["MAP_API_KEY"]

  def self.get_location_attributes(address)
    location = Geokit::Geocoders::GoogleGeocoder.geocode(address)
    if location.present?
      location_data = {
        long: location.lng,
        lat: location.lat,
        country: location.country,
        city: location.city,
        full_address: location.full_address,
        district: location.district,
        zip_code: location.zip
      }
      return location_data
    else
      return false
    end
  end

  def self.get_location_attributes_by_reverse(coordinates)
    location = Geokit::Geocoders::GoogleGeocoder.reverse_geocode(coordinates)
    if location.present?
      location_data = {
        long: location.lng,
        lat: location.lat,
        country: location.country,
        city: location.city,
        full_address: location.full_address,
        district: location.district,
        zip_code: location.zip
      }
      return location_data
    else
      return false
    end
  end

  def self.get_coordinates_by_zip_code(zip_code)
    location = Geokit::Geocoders::GoogleGeocoder.geocode('', components: {postal_code: zip_code})
    if location&.lat.present?
      { lat: location.lat, lng: location.lng }
    else
      nil
    end
  end
end
