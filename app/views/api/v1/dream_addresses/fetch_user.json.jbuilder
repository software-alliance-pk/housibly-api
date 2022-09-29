json.user_detail @user_prefernce do |user_prefernce|
	json.user_id user_prefernce.user_id
	json.user_image user_prefernce.user.avatar.attached? ? rails_blob_url(user_prefernce.user.avatar) : ""
	json.user_name user_prefernce.user.full_name
	json.weight_age user_prefernce.weight_age
	json.min_price user_prefernce.min_price
	json.max_price user_prefernce.max_price
end
