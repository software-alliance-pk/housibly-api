class SupportConversationChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    SupportConversation.where(sender_id: current_user).or(SupportConversation.where(recipient_id: current_user)).find_each do |conversation|
      stream_from "support_conversations_#{conversation.id}"
    end
    #current_user.update(available: true)
  end

  def unsubscribed
    stop_all_streams
    #current_user.update(available: false)
  end

  def receive(data)
    sender = get_sender(data)
    support_conversation_id = data['support_conversation_id']
    message = data['body']

    raise 'No support_conversation_id!' if support_conversation_id.blank?
    convo = get_convo(support_conversation_id)
    raise 'No support conversation found!' if convo.blank?
    raise 'Body is blank!' if message.blank?
    convo.support_messages.create(body: message, sender_id: sender.id, user_id: current_user.id)


      #   @conversation = SupportConversation.find_by(id: data.fetch("conversation_id"))
      #   if check_conversation(@conversation)
      #     message = @conversation.user_support_messages.build(sender_id: current_user.id)
      #     message.body = data["body"].present? ? data.fetch("body") : nil
      #     if message.save
      #       data = {}
      #       data["id"] = message.id
      #       data["conversation_id"] = message.support_conversation_id
      #       data["body"] = message.body
      #       data["user_id"] = message.sender_id
      #       data["created_at"] = message.created_at
      #       data["updated_at"] = message.updated_at
      #       ActionCable.server.broadcast "support_conversations_#{message.support_conversation_id}", data.as_json
            
      #     end
      #   end
      # end
      # def check_conversation(user)
      #   (user.sender_id == current_user.id) || (user.recipient_id == current_user.id)
  end

  def get_convo(support_conversation_id)
    SupportConversation.find_by(id: support_conversation_id)
  end
  
  def get_sender(data)
    User.find_by(id: data['sender_id'])
  end
end
