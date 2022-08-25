json.review do
	json.id @review.id
	json.review @review.description
	json.rating @review.rating
	json.reviewed_user_id @review.user_id
	json.support_closer_id @review.support_closer_id
  json.support_closer_image @review.support_closer.avatar.attached? ? rails_blob_url(@review.support_closer.avatar) : ""
end