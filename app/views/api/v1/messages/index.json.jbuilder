json.messages @messages.each do |message|
  json.id message.id
  json.body message.body
  json.user_id message.user_id
  json.sender_id message.conversation.sender_id
  json.recipient_id message.conversation.recipient_id
  json.conversation_id message.conversation_id
  json.created_at message.created_at
  json.updated_at message.updated_at

    json.uploded_images message.try(:images) do |image|
      json.image rails_blob_url(image) rescue ""
    end
end
