json.array! @conversations&.each do |conversation|
  last_message = conversation&.messages&.last
  json.id conversation.id
  json.recipient_id conversation.recipient_id
  json.sender_id conversation.sender_id
  json.created_at conversation.created_at
  json.updated_at conversation.updated_at
  json.unread_message conversation_read_message_counter(last_message)
  json.is_blocked conversation.is_blocked
  json.message last_message.body
  json.full_name conversation_get_full_name(conversation)
  json.avatar conversation_get_user_avatar(conversation)
end