json.user_detail @property do |property|
	json.user_id property.user_id
	json.user_image property.user.avatar.attached? ? rails_blob_url(property.user.avatar) : ""
	json.user_name property.user.full_name
	json.weight_age property.weight_age
	json.min_price property.min_price
	json.max_price property.max_price
	json.last_seen "#{time_ago_in_words(property.user.last_seen)} ago"
	if  property.created_at > 6.weeks.ago
		json.is_new true
	else
		json.is_new false
	end
end
