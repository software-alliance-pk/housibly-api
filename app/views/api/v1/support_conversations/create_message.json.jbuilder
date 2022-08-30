json.message do
	json.id @message.id
	json.user_id @message.user_id
	json.message @message.body
	json.conversation_id @message.support_conversation_id
	json.created_at @message.created_at
	json.updated_at @message.updated_at
	json.image @message.image&.attached? ? @message.image.url : ""

end