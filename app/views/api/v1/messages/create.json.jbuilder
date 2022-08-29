json.message do
	json.id @message.id
	json.user_id @message.user_id
	json.conversation_id @message.conversation_id
	json.uploded_images @message.images do |image|
		json.image rails_blob_url(image) rescue ""
	end
end
