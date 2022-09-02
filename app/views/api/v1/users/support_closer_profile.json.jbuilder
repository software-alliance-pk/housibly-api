json.support_closer do 
  json.id @support_closer.id
  json.full_name @support_closer.full_name
  json.email @support_closer.email
  json.is_otp_verified @support_closer.is_otp_verified
  json.is_confirmed @support_closer.is_confirmed
  json.phone_number @support_closer.phone_number
  json.country_code @support_closer.country_code
  json.country_name @support_closer.country_name
  json.licensed_realtor @support_closer.licensed_realtor
  json.contacted_by_real_estate @support_closer.contacted_by_real_estate
  json.user_type @support_closer.user_type
  json.profile_type @support_closer.profile_type
  json.description @support_closer.description
  json.rating @support_closer.support_closer_reviews.pluck(:rating).sum/5
  json.profile_images @support_closer.avatar.attached? ? @support_closer.avatar.url : ""
  json.professions  @support_closer.professions do |profession|
  	json.title profession.title
  end
  json.uploded_images @support_closer.images do |image|
    json.image rails_blob_url(image) rescue ""
  end
  json.certificates @support_closer.certificates do |certificate|
    json.certificate certificate.url rescue ""
     json.size certificate.byte_size rescue ""
  end
end