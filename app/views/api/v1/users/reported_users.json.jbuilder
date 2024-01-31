json.reported_users @reported_users do |reported_user|
	json.user_id reported_user.id
	json.full_name reported_user.full_name
	json.avatar reported_user.avatar.attached? ? rails_blob_url(reported_user.avatar) : ""
end