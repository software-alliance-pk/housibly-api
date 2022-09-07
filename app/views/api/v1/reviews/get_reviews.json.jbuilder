json.total_reviews @reviews.count
if @reviews.pluck(:rating).sum/5 == 0
  json.average_rating 1
else
  json.average_rating @reviews.pluck(:rating).sum/5
end
json.reviews @reviews do |review|
	json.id review.id
	json.review review.description
	json.rating review.rating
	json.reviewed_user_id review.user_id
	json.reviewed_user_name review.user.full_name
	json.support_closer_id review.support_closer_id
	json.reviewed_user_image review.user.avatar.attached? ? rails_blob_url(review.user.avatar) : ""
    json.support_closer_image review.support_closer.avatar.attached? ? rails_blob_url(review.support_closer.avatar) : ""
end