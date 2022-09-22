json.blocked_users @conversation_blocked do |conversation_blocked|
  if conversation_blocked.block_by == @current_user.id
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts conversation_blocked.block_by
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts @current_user.id
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    json.id conversation_blocked.id
    if conversation_blocked.sender == @current_user
      json.full_name conversation_blocked.recipient&.full_name
    else
      json.full_name conversation_blocked.sender&.full_name
    end
    if conversation_blocked.sender == @current_user
      json.blocked_user_id conversation_blocked.recipient&.id
    else
      json.blocked_user_id conversation_blocked.sender&.id
    end
    if conversation_blocked.sender == @current_user
      json.avatar conversation_blocked.recipient.avatar.attached? ? rails_blob_url(conversation_blocked.recipient.avatar) : ""
    else
      json.avatar conversation_blocked.sender.avatar.attached? ? rails_blob_url(conversation_blocked.sender.avatar) : ""
    end
  end
end