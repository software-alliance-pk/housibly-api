json.user do
  json.id @user.id
  json.full_name @user.full_name
  json.email @user.email
  json.is_otp_verified @user.is_otp_verified
  json.is_confirmed @user.is_confirmed
  json.phone_number @user.phone_number
  json.country_code @user.country_code
  json.country_name @user.country_name
  json.licensed_realtor @user.licensed_realtor
  json.contacted_by_real_estate @user.contacted_by_real_estate
  json.user_type @user.user_type
  json.profile_type @user.profile_type
  json.description @user.description
  json.image @user.avatar.attached? ? @current_user.avatar.url : ""

end