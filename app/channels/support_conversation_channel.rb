class SupportConversationChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    SupportConversation.where(sender_id: current_user).or(SupportConversation.where(recipient_id: current_user)).find_each do |conversation|
      stream_from "support_conversations_#{conversation.id}"
   end
 end

  def unsubscribed
    stop_all_streams
  end

  def receive(data)
    @conversation = SupportConversation.find_by(id: data.fetch("conversation_id"))
    if (@conversation.sender_id == current_user.id) || (@conversation.recipient_id == current_user.id)
      message = @conversation.user_support_messages.build(sender_id: current_user.id)
      message.body = data["body"].present? ? data.fetch("body") : nil
      if message.save
        data = {}
        data["id"] = message.id
        data["conversation_id"] = message.support_conversation_id
        data["body"] = message.body
        data["user_id"] = message.sender_id
        data["created_at"] = message.created_at
        data["updated_at"] = message.updated_at
        ActionCable.server.broadcast "support_conversations_#{message.support_conversation_id}", data.as_json
      end
    
    end
  end
end
