json.array! @conversations&.each do |conversation|
  json.conversation conversation
  json.message conversation&.messages&.last&.body
  if conversation.sender == @current_user
    json.full_name conversation.recipient&.full_name
  else
    json.full_name conversation.sender&.full_name
  end
end