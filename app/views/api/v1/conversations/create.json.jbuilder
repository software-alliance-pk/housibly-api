  json.conversation @conversation do |conversation|
  json.conversation_id conversation.id

  if conversation.sender == @current_user
    json.full_name conversation.recipient&.full_name
  else
    json.full_name conversation.sender&.full_name
  end
  if conversation.sender == @current_user
  	json.avatar conversation.recipient.avatar.attached? ? rails_blob_url(conversation.recipient.avatar) : ""
  else
    	json.avatar conversation.sender.avatar.attached? ? rails_blob_url(conversation.sender.avatar) : ""

end
end