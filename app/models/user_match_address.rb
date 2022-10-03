class UserMatchAddress < ApplicationRecord
	has_many :users
	has_many :user_search_addresses
end
