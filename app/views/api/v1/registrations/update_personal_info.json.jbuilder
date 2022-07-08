json.user do
  json.id @current_user.id
  json.name @current_user.full_name
  json.email_address @current_user.email
  json.phone_number @current_user.phone_number
  json.is_otp_verified @current_user.is_otp_verified
  json.licensed_realtor @current_user.licensed_realtor
  json.contacted_by_real_estate @current_user.contacted_by_real_estate
  json.user_type @current_user.user_type
  json.profile_type @current_user.profile_type
  json.image @current_user.avatar.attached? ? rails_blob_url(@current_user.avatar) : " "
  json.description @current_user.description
end