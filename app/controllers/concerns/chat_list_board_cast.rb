module ChatListBoardCast
  include ActiveSupport::Concern

  def notify_second_user(conversation)
    user = conversation.sender == current_user ? conversation.recipient :  conversation.sender
    @list = Conversation.find_user_conversations(user.id)
    return @list,user
  end

  def get_full_name(conversation)
    if conversation&.sender == @current_user
      conversation.recipient&.full_name
    else
      conversation&.sender&.full_name
    end
  end
  
  def get_avatar(conversation)
    if conversation&.sender == @current_user
      conversation.recipient&.avatar&.url
    else
      conversation&.sender&.avatar&.url
    end
  end  

  def un_read_counter(conversation)
    user = conversation&.sender == @current_user ? conversation.recipient : conversation.sender
    conversation.messages&.where(read_status: false).where.not(user_id:user).count
  end


  # def  get_extra_data_of_compile_message(message)
  #   conversation = message&.conversation
  #   _full_name,_image,_un_read_message_count = '','',''
  #   return _full_name, _image, _un_read_message_count unless  conversation.present?
  #   _full_name = 
  #   _image = 
  #   _un_read_message_count = 
  #   puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
  #   puts _un_read_message_count
  #   puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
  #   return _full_name,_image,_un_read_message_count
  # end

  def compile_message(conversation, message = nil)
    message ||= conversation.messages.last
    data = {}
  
    data["unread_message"] = un_read_counter(conversation)
    data["full_name"] = get_full_name(conversation)
    data["avatar"] = get_avatar(conversation)
    data["conversation_id"] = conversation.id
    data["recipient_id"] = conversation.recipient_id
    data["sender_id"] = conversation.sender_id
    data["created_at"] = conversation.created_at
    data["updated_at"] = conversation.updated_at
    data["is_blocked"] = conversation.is_blocked
    data["user_id"] = message&.user_id
    data["id"] = message&.id
  
    if message.present?
      data["message"] = message.body.present? ? message.body : (message.image.present? ? "Image" : "")
      data["image"] = message.image.present? ? chat_avatar_image(message) : ""
      data["body"] = message.body.present? ? message.body : ""
    else
      data["message"] = ""
      data["image"] = ""
      data["body"] = ""
    end
  
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts " Current User Name:#{@current_user.full_name} << AND >> Recipient Name: #{get_full_name(conversation)} "
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    return data
  end
  
  
  def chat_avatar_image(message)
    if message && message.image.present? && message.image.attached?
      message.image.url
    else
      ""
    end
  end
end