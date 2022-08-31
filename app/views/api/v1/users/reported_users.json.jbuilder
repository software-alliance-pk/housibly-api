json.reported_users @reported_users do |reported_user|
	json.id reported_user.id
	json.name reported_user.full_name
	json.profile_image reported_user.avatar.attached? ? rails_blob_url(reported_user.avatar) : ""
end