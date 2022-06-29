json.user do
  json.name @user.full_name
  json.email_address @user.email
  json.phone_number @user.phone_number
  json.licensed_realtor @user.licensed_realtor
  json.contacted_by_real_estate @user.contacted_by_real_estate
  json.user_type @user.user_type
  json.profile_type @user.profile_type
  json.image url_for(@user.avatar)
  json.description @user.description
end