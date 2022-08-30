json.messages @messages.each do |message|
  json.id message.id
  json.body message.body
  json.user_id message.user_id
  json.sender_id message.support_conversation.sender_id
  json.recipient_id message.support_conversation.recipient_id
  json.conversation_id message.support_conversation_id
  json.created_at message.created_at
  json.updated_at message.updated_at
  json.image message.image&.attached? ? message.image.url : ""

end
