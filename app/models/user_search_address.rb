class UserSearchAddress < ApplicationRecord
	belongs_to :user
	belongs_to :searched_address
end
