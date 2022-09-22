class ChatListChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_chat_list_#{current_user.id}"
  end
  def receive(data)
    #did for testing
    @list = current_user.conversations
    if @list.exists?
      data = {}
      data["list"] = @list
      ActionCable.server.broadcast "user_chat_list_#{current_user.id}", data.as_json
    end
  end
  def unsubscribed
    stop_stream_from "user_chat_list__#{current_user.id}"
  end
end
