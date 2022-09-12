json.conversation do
  json.id @conversation.id
  json.recipient_id @conversation.recipient_id
  json.sender_id @conversation.sender_id
  json.created_at @conversation.created_at
  json.updated_at @conversation.updated_at
  json.is_blocked @conversation.is_blocked
  json.unread_message @conversation.unread_message
  if @conversation.sender == @current_user
    json.full_name @conversation.recipient&.full_name
  else
    json.full_name @conversation.sender&.full_name
  end
  if @conversation.sender == @current_user
    json.avatar @conversation.recipient.avatar.attached? ? rails_blob_url(@conversation.recipient.avatar) : ""
  else
    json.avatar @conversation.sender.avatar.attached? ? rails_blob_url(@conversation.sender.avatar) : ""
  end
end