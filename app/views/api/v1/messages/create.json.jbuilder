json.message do
	json.id @message.id
	json.user_id @message.user_id
	json.message @message.body
	json.conversation_id @message.conversation_id
	json.created_at @message.created_at
	json.updated_at @message.updated_at
	json.uploded_images @message.images do |image|
		json.image rails_blob_url(image) rescue ""
	end
end
