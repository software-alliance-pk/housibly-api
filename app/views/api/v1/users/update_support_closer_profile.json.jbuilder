json.current_user do 
  json.id @current_user.id
  json.full_name @current_user.full_name
  json.email @current_user.email
  json.phone_number @current_user.phone_number
  json.profile_type @current_user.profile_type
  json.description @current_user.description
  json.rate @current_user.currency_amount
  json.country_name @current_user.country_name
  json.country_code @current_user.country_code
  json.profile_images @current_user.avatar.attached? ? @current_user.avatar.url : ""
  json.professions  @current_user.professions do |profession|
  	json.title profession.title
  end
  json.uploded_images @current_user.images do |image|
    json.image rails_blob_url(image) rescue ""
  end
end