module Api::V1::ConversationsHelper
  # def  get_extra_data_of_compile_message(message)
  #   conversation = message&.conversation
  #   _full_name,_image,_un_read_message_count = '','',''
  #   return _full_name, _image, _un_read_message_count unless  conversation.present?
  #   _full_name = get_full_name(conversation)
  #   _image = get_avatar(conversation)
  #   _un_read_message_count= un_read_counter(conversation)
  #   return _full_name,_image,_un_read_message_count
  # end

  def get_full_name(conversation)
    conversation&.sender == @current_user ? conversation.recipient&.full_name : conversation&.sender&.full_name
  end

  def get_avatar(conversation)
    conversation&.sender == @current_user ? conversation.recipient&.avatar&.url : conversation&.sender&.avatar&.url
  end

  def un_read_counter(conversation)
    _user =  conversation&.sender == @current_user ?  conversation.sender : conversation.recipient
    conversation.messages&.where(read_status: false).where.not(user_id:_user).count
  end

  # def compile_message(conversation)
  #   message = conversation.messages.last
  #   full_name,image,un_read_message_count, = get_extra_data_of_compile_message(message)
  #   return full_name,image,un_read_message_count
  # end

  def mark_conversation_for_sender(conversation,message)
    conversation.messages.mark_as_read! :all, for: conversation.sender  if @current_user == conversation.sender
    conversation.messages.mark_as_read! :all, for: conversation.recipient if  @current_user == conversation.recipient
  end
end
