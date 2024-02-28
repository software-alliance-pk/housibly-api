class SearchedAddress < ApplicationRecord
	acts_as_mappable default_units: :kms,
									lat_column_name: :latitude,
									lng_column_name: :longitude

	has_many :user_search_addresses, dependent: :destroy
	has_many :users, through: :user_search_addresses

	validates_presence_of :address, :latitude, :longitude
end
