class SchoolPin < ApplicationRecord
	validates :longtitude, :latitude, :pin_name, presence: true
	reverse_geocoded_by :latitude, :longtitude
    after_validation :reverse_geocode
end
