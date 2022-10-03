json.users_detail @users do |user|
	json.user_id user.id
	json.user_full_name user.full_name
	json.user_avatar user.avatar.attached? ? rails_blob_url(user.avatar) : ""
	json.min_price user.user_preference&.min_price
	json.max_price user.user_preference&.max_price
	# json.user_match_address user_search.user_match_address.address
end