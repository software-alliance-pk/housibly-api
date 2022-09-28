json.user_detail @property do |property|
	json.user_id property.user_id
	json.user_image property.user.avatar.attached? ? rails_blob_url(property.user.avatar) : ""
	json.user_name property.user.full_name
	json.weight_age property.weight_age
	json.min_price property.min_price
	json.max_price property.max_price
end
