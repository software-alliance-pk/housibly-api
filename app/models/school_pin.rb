class SchoolPin < ApplicationRecord
	after_create :update_school_pin
	validates :longtitude, :latitude, :pin_name, presence: true
	has_one_attached :image
	def update_school_pin
		res = LocationFinderService.get_location_attributes_by_reverse("#{self.latitude},#{self.longtitude}")
		address = res[:full_address]
		city = res[:city]
		country = res[:country]
		self.update(city:city, country:country,address: address)
	end

end
