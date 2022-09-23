module Api::V1::ConversationsHelper
  def conversation_read_message_counter(message)
    conversation = message.conversation
    if message.user == @current_user
      conversation.recipient.have_read?(message) == true ? 0 : count_un_read_message_for_conversation(message.conversation)
    else
      conversation.sender.have_read?(message) == true ? 0 : count_un_read_message_for_conversation(message.conversation)
    end
  end

  def count_un_read_message_for_conversation(conversation)
    if conversation.sender == @current_user
      puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      conversation.messages.with_read_marks_for(conversation.recipient).
        map { |item| true if item.unread?(conversation.recipient)}&.compact&.count
    else
      conversation.messages.with_read_marks_for(conversation.sender).
        map { |item| true if item.unread?(conversation.sender)}&.compact&.count
    end
  end

  def conversation_get_full_name(conversation)
    if conversation.sender == @current_user
      conversation.recipient&.full_name
    else
      conversation.sender&.full_name
    end
  end

  def conversation_get_user_avatar(conversation)
    if conversation.sender == @current_user
       conversation.recipient.avatar.attached? ? rails_blob_url(conversation.recipient.avatar) : ""
    else
      conversation.sender.avatar.attached? ? rails_blob_url(conversation.sender.avatar) : ""
    end
  end
end
