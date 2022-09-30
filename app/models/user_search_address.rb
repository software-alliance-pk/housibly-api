class UserSearchAddress < ApplicationRecord
	belongs_to :user
	belongs_to :user_match_address
end
