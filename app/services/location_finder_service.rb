
class LocationFinderService
  Geokit::Geocoders::GoogleGeocoder.api_key = "AIzaSyBq3-UEY9QO9X45s8w54-mrwjBQekzDlsA"

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
end