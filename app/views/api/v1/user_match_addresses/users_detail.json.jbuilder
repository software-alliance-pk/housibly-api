json.users_detail @users do |user_search|
	json.user_id user_search.user_id
	json.user_full_name user_search.user.full_name
	json.user_avatar user_search.user.avatar.attached? ? rails_blob_url(user_search.user.avatar) : ""
	json.min_price user_search.user.user_preference&.min_price
	json.max_price user_search.user.user_preference&.max_price
	json.user_match_address user_search.user_match_address.address
end