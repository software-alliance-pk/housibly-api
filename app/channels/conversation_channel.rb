class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    # Conversation.where(sender_id: current_user).or(Conversation.where(recipient_id: current_user)).find_each do |conversation|
    #   stream_from "conversations_#{conversation.id}"
    # end
    Conversation.get_all_conversation_of_specific_user(current_user.id).find_each do |conversation|
      stream_from "conversations_#{conversation.id}"
    end
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(data)
    @conversation = Conversation.find_by(id: data.fetch("conversation_id"))
    # if (@conversation.sender_id == current_user.id) || (@conversation.recipient_id == current_user.id)
    if check_conversation(@conversation)
      message = @conversation.messages.build(user_id: current_user.id)
      message.body = data["body"].present? ? data.fetch("body") : nil
      if message.save
        data = {}
        data["id"] = message.id
        data["conversation_id"] = message.conversation_id
        data["body"] = message.body
        data["user_id"] = message.user_id
        data["image"] = message.image
        data["created_at"] = message.created_at
        data["updated_at"] = message.updated_at
        ActionCable.server.broadcast "conversations_#{message.conversation_id}", data.as_json
      end
    end
  end

  def check_conversation(user)
    (user.sender_id == current_user.id) || (user.recipient_id == current_user.id)
  end

end

