json.profile do
  json.id @current_user.id
  json.full_name @current_user.full_name
  json.email @current_user.email
  json.phone_number @current_user.phone_number
  json.licensed_realtor @current_user.licensed_realtor
  json.user_type @current_user.user_type
  json.profile_type @current_user.profile_type
  json.image  @current_user.profile_type
end