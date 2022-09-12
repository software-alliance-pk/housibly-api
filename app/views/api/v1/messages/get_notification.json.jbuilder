json.notification @notifications.each do |notification|
	json.id notification&.id
	json.title notification&.title
	json.recipient_id notification&.recipient_id
	json.sender_id notification&.actor_id
	json.conversation_id notification.conversation_id
	json.sender_avatar notification&.actor&.avatar&.attached? ? rails_blob_url(notification&.actor&.avatar) : ""
	json.action notification&.action
	json.created_at notification&.created_at
	json.updated_at notification&.updated_at
end