class SchoolPin < ApplicationRecord
	after_create :update_school_pin
	validates :longtitude, :latitude, :pin_name, presence: true
	reverse_geocoded_by :latitude, :longtitude
	after_validation :reverse_geocode
	has_one_attached :image
	def update_school_pin
		long = self.longtitude
		lat = self.latitude
		geocoder_address = Geocoder.search([lat,long]).first
		address = geocoder_address.address
		city = geocoder_address.city
		country = geocoder_address.country
		self.update(city:city, country:country)
	end


end
