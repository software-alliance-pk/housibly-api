json.total_user_count @total_user_count
json.users @users do |user|
  json.id user.id
  json.full_name user.full_name
  json.avatar user.avatar.attached? ? rails_blob_url(user.avatar) : ""
  json.budget user.user_preference.price
end
