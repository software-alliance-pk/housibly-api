json.blocked_users @blocked_users do |blocked_user|
	json.id blocked_user.id
	json.name blocked_user.full_name
	json.profile_image blocked_user.avatar.attached? ? rails_blob_url(blocked_user.avatar) : ""
end