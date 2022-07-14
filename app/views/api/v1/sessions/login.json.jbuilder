json.user do
  json.auth_token @token
  json.id @user.id
  json.name @user.full_name
  json.email_address @user.email
  json.phone_number @user.phone_number
  json.is_otp_verified @user.is_otp_verified
  json.is_confirmed @user.is_confirmed
  json.licensed_realtor @user.licensed_realtor
  json.contacted_by_real_estate @user.contacted_by_real_estate
  json.user_type @user.user_type
  json.profile_type @user.profile_type
  json.image @user.avatar.attached? ? rails_blob_url(@user.avatar) : ""
  json.description @user.description
end