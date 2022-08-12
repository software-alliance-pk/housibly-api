json.user do
  json.id @current_user.id
  json.full_name @current_user.full_name
  json.email @current_user.email
  json.is_otp_verified @current_user.is_otp_verified
  json.is_confirmed @current_user.is_confirmed
  json.phone_number @current_user.phone_number
  json.country_code @current_user.country_code
  json.country_name @current_user.country_name
  json.licensed_realtor @current_user.licensed_realtor
  json.contacted_by_real_estate @current_user.contacted_by_real_estate
  json.user_type @current_user.user_type
  json.profile_type @current_user.profile_type
  json.description @current_user.description
  json.image @current_user.avatar.attached? ? @current_user.avatar.url : ""
  json.images @current_user.images do |image|
    json.image rails_blob_url(image) rescue ""
  end
  json.certificates @current_user.certificates do |certificate|
    json.image certificate.url rescue ""
  end

end
