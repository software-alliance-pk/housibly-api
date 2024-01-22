json.conversation do
  json.id @conversation.id
  json.recipient_id @conversation.recipient_id
  json.sender_id @conversation.sender_id
  json.created_at @conversation.created_at
  json.updated_at @conversation.updated_at
  json.is_blocked @conversation.is_blocked
  json.unread_message un_read_counter(@conversation)
  json.full_name get_full_name(@conversation)
  json.avatar get_avatar(@conversation)
end