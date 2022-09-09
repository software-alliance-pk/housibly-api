json.messages @messages.each do |message|
  json.id message.id
  json.body message.body
  json.user_id message.sender_id
  json.sender_id message.support_conversation.user
  json.recipient_id Admin.admin.first
  json.conversation_id message.support_conversation_id
  json.created_at message.created_at
  json.updated_at message.updated_at
  json.image message.image&.attached? ? message.image.url : ""

end
