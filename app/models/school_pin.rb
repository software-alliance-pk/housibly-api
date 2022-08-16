class SchoolPin < ApplicationRecord
	validates :longtitude, :latitude, :pin_name, presence: true
end
