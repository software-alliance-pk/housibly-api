json.unblocked_users @unblocked_users do |unblocked_user|
	json.id unblocked_user.id
  json.full_name unblocked_user.full_name
  json.email unblocked_user.email
  json.is_otp_verified unblocked_user.is_otp_verified
  json.is_confirmed unblocked_user.is_confirmed
  json.phone_number unblocked_user.phone_number
  json.country_code unblocked_user.country_code
  json.country_name unblocked_user.country_name
  json.licensed_realtor unblocked_user.licensed_realtor
  json.contacted_by_real_estate unblocked_user.contacted_by_real_estate
  json.user_type unblocked_user.user_type
  json.profile_type unblocked_user.profile_type
  json.description unblocked_user.description
  json.image unblocked_user.avatar.attached? ? @current_user.avatar.url : ""
end

