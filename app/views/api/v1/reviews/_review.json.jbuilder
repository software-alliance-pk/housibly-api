json.id review.id
json.rating review.rating
json.description review.description
json.user do
  json.id review.user_id
  json.full_name review.user.full_name
  json.avatar review.user.avatar.attached? ? rails_blob_url(review.user.avatar) : ""
end
