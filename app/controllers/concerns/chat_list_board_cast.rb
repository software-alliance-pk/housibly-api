module ChatListBoardCast
  include ActiveSupport::Concern

  def notify_second_user(conversation)
    user = conversation.sender == current_user ? conversation.recipient :  conversation.sender
    @list = Conversation.find_specific_conversation(user.id)
    return @list,user
  end

  def get_full_name(conversation)
    conversation&.sender == @current_user ? conversation.recipient&.full_name : conversation&.sender&.full_name
  end

  def get_avatar(conversation)
    conversation&.sender == @current_user ? conversation.recipient&.avatar&.url : conversation&.sender&.avatar&.url
  end

  def un_read_counter(conversation)
    conversation.messages&.where(read_status: false).where.not(user_id:@current_user).count
  end


  def  get_extra_data_of_compile_message(message)
    conversation = message&.conversation
    _full_name,_image,_un_read_message_count = '','',''
    return _full_name, _image, _un_read_message_count unless  conversation.present?
    _full_name = get_full_name(conversation)
    _image = get_avatar(conversation)
    _un_read_message_count = un_read_counter(conversation)
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts _un_read_message_count
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    return _full_name,_image,_un_read_message_count
  end

  def compile_message(conversation)
    message = conversation.messages.last
    data = {}
    full_name,image,un_read_message_count, = get_extra_data_of_compile_message(message)
    data["unread_message"] = un_read_message_count
    data["full_name"] =  full_name
    data["avatar"] = image
    data["conversation_id"] = conversation.id
    data["recipient_id"] = conversation.recipient_id
    data["sender_id"] = conversation.sender_id
    data["created_at"] = conversation.created_at
    data["updated_at"] = conversation.updated_at
    data["is_blocked"] = conversation.is_blocked
    data["user_id"] = message&.user_id
    data["message"] = message.present? ? message.body : "No Message"
    data["body"] =  message.present? ? message.body : "No Message"
    data["id"] =  message.present? ? message.id : "No Message"
    data["image"] = message.present? ? (chat_avatar_image(message)) : "No Message"
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts "            User Name: #{full_name}                     "
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts "            Current User Name: #{@current_user.full_name}        "
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    return data
  end

  def chat_avatar_image(message)
    message.image.attached? ? message.image.url : ""
  end
end