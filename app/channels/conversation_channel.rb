class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    if current_user.present?
      Conversation.get_all_conversation_of_specific_user(current_user.id).find_each do |conversation|
        stream_from "conversations_#{conversation.id}"
      end
    end
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(data)
    args = data["args"]
    return unless args && args["conversation_id"].present?
  
    conversation_id = args["conversation_id"]
    @conversation = Conversation.find_by(id: conversation_id)
  
    if current_user && check_conversation(@conversation)
      message = @conversation.messages.build(user_id: current_user.id)
      message.body = args["body"].presence
      if message.save
        broadcast_message(message)
      end
    end
  end
  
  def broadcast_message(message)
    data = {
      id: message.id,
      conversation_id: message.conversation_id,
      body: message.body,
      user_id: message.user_id,
      image: message.image,
      created_at: message.created_at,
      updated_at: message.updated_at
    }
  
    ActionCable.server.broadcast "conversations_#{message.conversation_id}", data.as_json
  end
  
  def check_conversation(conversation)
    return false unless conversation

    (conversation.sender_id == current_user.id) || (conversation.recipient_id == current_user.id)
  end

end
