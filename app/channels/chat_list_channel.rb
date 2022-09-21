class ChatListChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "user_chat_list_#{current_user.id}"
     # Conversation.get_all_conversation_of_specific_user(current_user.id).find_each do |conversation|
     #  stream_from "user_chat_list__#{conversation&.sender_id}"
     #  stream_from "user_chat_list__#{conversation&.recipient_id}"


    end
  end

  def receive(data)
    @list = current_user.conversations
    if @list.exists?
      data = {}
      data["list"] = @list
      ActionCable.server.broadcast "user_chat_list_#{current_user.id}", data.as_json
    end
  end


  def unsubscribed
    stop_all_streams
  end
end
