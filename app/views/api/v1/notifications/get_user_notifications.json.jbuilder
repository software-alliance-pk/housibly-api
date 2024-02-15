json.array! @notifications do |notification|
	json.id notification&.id
	json.property_id notification.property_id
	json.property_image (rails_blob_url(notification.property.images.first) rescue "")
	json.title notification&.title
	json.type notification&.event_type
	json.seen notification.seen
	json.recipient_id notification&.recipient_id
	json.sender_id notification&.actor_id
	json.conversation_id notification&.conversation_id
	json.is_blocked notification&.conversation&.is_blocked
	json.sender_avatar notification&.actor&.avatar&.attached? ? rails_blob_url(notification&.actor&.avatar) : ""
	json.action notification&.action
	json.sender_name notification&.actor&.full_name
	json.created_at notification&.created_at
	json.updated_at notification&.updated_at
end
