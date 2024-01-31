json.unblocked_users @conversation_unblocked do |conversation_unblocked|
  
  json.conversation_id conversation_unblocked.id

  json.recipient_full_name conversation_unblocked.recipient&.full_name
  json.sender_full_name conversation_unblocked.sender&.full_name
  
  json.recipient_user_id conversation_unblocked.recipient&.id
  json.sender_user_id conversation_unblocked.sender&.id
  
  json.recipient_avatar conversation_unblocked.recipient.avatar.attached? ? rails_blob_url(conversation_unblocked.recipient.avatar) : ""
  json.sender_avatar conversation_unblocked.sender.avatar.attached? ? rails_blob_url(conversation_unblocked.sender.avatar) : ""
     
end