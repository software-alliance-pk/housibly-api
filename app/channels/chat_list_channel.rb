class ChatListChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "user_chat_list_#{current_user.id}"
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
