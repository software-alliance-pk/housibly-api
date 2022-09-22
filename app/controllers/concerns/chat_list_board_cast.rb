module ChatListBoardCast
  include ActiveSupport::Concern

  def notify_second_user(conversation)
    user = conversation.sender == current_user ? conversation.recipient :  conversation.sender
    @list = Conversation.find_specific_conversation(user.id)
    return @list,user
  end

  def debug_purpose(conversation,message)
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts  (message.user == conversation.sender)  && (@current_user == message.user) ? conversation.unread_message : 0
    puts  message.user.id
    puts conversation.sender.id
    puts @current_user.id
    puts (message.user == conversation.sender)
    puts (@current_user == message.user)
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
  end

  def get_full_name(conversation)
    conversation&.sender != @current_user ? conversation.recipient&.full_name : conversation&.sender&.full_name
  end

  def get_avatar(conversation)
    conversation&.sender != @current_user ? conversation.recipient&.avatar&.url : conversation&.sender&.avatar&.url
  end

  def get_message_count(message)
    if message.user_id != @current_user.id && message.conversation_id == @current_user.id
      0
    else
      message.conversation.unread_message
    end
  end

  def compile_conversation_boardcasting_data(conversation)
    message = conversation.messages.last
    debug_purpose(conversation,message)
    data = {}
    data["conversation_id"] = conversation.id
    data["recipient_id"] = conversation.recipient_id
    data["sender_id"] = conversation.sender_id
    data["created_at"] = conversation.created_at
    data["updated_at"] = conversation.updated_at
    data["is_blocked"] = conversation.is_blocked
    data["user_id"] = message.user_id
    data["message"] = message.body
    data["body"] = message.body
    data["id"] = message.id
    data["unread_message"] = get_message_count(message)
    data["full_name"] = get_full_name(conversation)
    data["avatar"] = get_avatar(conversation)
    data["image"] = message.image.attached? ? message.image.url : ""
    return data
  end
end