class Api::V1::ConversationsController < Api::V1::ApiController
  include ChatListBoardCast
  def create
    check_conversation_exists
    if @conversation.present?
     @conversation
   else
     @conversation = Conversation.new(conversation_params.merge(sender_id: current_user.id))
     if @conversation.save
      @conversation
    else
      render_error_messages(@conversation)
    end
  end
  @list,user = notify_second_user(@conversation)
  ActionCable.server.broadcast "user_chat_list_#{user.id}",  { data: @list.as_json}
end
def index
  @conversations = Conversation.find_specific_conversation(@current_user.id)
  sender_arr = []
  recipient_arr = []
  @conversations.each do |conversation|
    if conversation&.sender == @current_user
      sender_arr <<  recipient_compile_message(conversation)
    else
    recipient_arr << sender_compile_message(conversation)
    end
  end
    ActionCable.server.broadcast "user_chat_list_#{@conversation&.recipient_id}",  { data:  sender_arr.as_json}
    ActionCable.server.broadcast "user_chat_list_#{@conversation&.sender_id}",  { data:  recipient_arr.as_json}


end
def read_messages
  @conversation = Conversation.where("recipient_id = (?) OR  sender_id = (?) AND id = (?)", @current_user.id, @current_user.id, params[:conversation_id])
  if @conversation.present?
    @conversation.update(unread_message: 0)
    render json: { message: "message has been read" }, status: :ok
    data= {}
    data["recipient_id"] = @conversation.recipient_id
    data["sender_id"] = @conversation.sender_id
    data["created_at"] = @conversation.created_at
    data["updated_at"] = @conversation.updated_at
    data["unread_message"] = @conversation.unread_message
    data["is_blocked"] = @conversation.is_blocked
    data["message"] = @conversation.messages.last
    if @conversation&.sender == @current_user
      data["full_name"] = @conversation&.recipient&.full_name
    else
      data["full_name"]= @conversation&.sender&.full_name
    end
    if conversation&.sender == @current_user
      data["avatar"] = @conversation&.recipient&.avatar&.url
    else
      data["avatar"] = @conversation&.sender&.avatar&.url
    end
    if @conversation&.sender == @current_user
      ActionCable.server.broadcast "user_chat_list_#{@conversation&.recipient_id}",  { data:  data.as_json}
    else
      ActionCable.server.broadcast "user_chat_list_#{@conversation&.sender_id}",  { data:  data.as_json}
    end
  else
    render json: { error: "No such conversation exists" }, status: :unprocessable_entity
  end
end

def destroy
  @conversation = Conversation.find_by(id: params[:id])
  if @conversation.present?
    @conversation.delete
    render json: { message: "Conversation is successfully deleted" }, status: :ok
  else
    render json: { error: "No Found" }, status: :unprocessable_entity
  end
end
def notification_token
  if params[:token].present?
    token = @current_user.mobile_devices.find_or_create_by(mobile_device_token: params[:token])
    if token.save
      render json: { message: 'Success', status: 'ok', token: token }
    end
  end
end
def logout
  mtoken = @current_user.mobile_devices.find_by(mobile_device_token:params[:mtoken])
  if mtoken.present?
    mtoken.destroy
    render json: {message: "Log out successfully"},status: :ok
  end
end

private
def conversation_params
  params.require(:conversation).permit(:recipient_id)
end

def check_conversation_exists
  @conversation = Conversation.get_chat_between_user(params[:conversation][:recipient_id],@current_user.id)
  unless @conversation.present?
    @conversation = Conversation.with_deleted.
    get_chat_between_user(params[:conversation][:recipient_id],@current_user.id)
    @conversation.recover if @conversation.present?
  end
end

  def sender_compile_message(conversation)
    message = conversation.messages.last
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts  (message.user == conversation.sender)  && (@current_user == message.user) ? conversation.unread_message : 0
    puts  message.user.id
    puts conversation.sender.id
    puts @current_user.id
    puts (message.user == conversation.sender)
    puts (@current_user == message.user)
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    data = {}
    data["recipient_id"] = conversation.recipient_id
    data["sender_id"] = conversation.sender_id
    data["created_at"] = conversation.created_at
    data["updated_at"] = conversation.updated_at
    data["is_blocked"] = conversation.is_blocked
    data["message"] = message.body
    data["unread_message"] = (message.user == conversation.sender)  && (@current_user == message.user)  ? 0 : conversation.unread_message
    if conversation&.sender == @current_user
      data["full_name"] = conversation&.recipient&.full_name
    else
      data["full_name"]= conversation&.sender&.full_name
    end
    if conversation&.sender == @current_user
      data["avatar"] = conversation&.recipient&.avatar&.url
    else
      data["avatar"] = conversation&.sender&.avatar&.url

    end
    return data
  end

  def recipient_compile_message(conversation)
    message = conversation.messages.last
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts  (message.user == conversation.recipient)  && (@current_user == message.user) ? 0 : conversation.unread_message
    puts  message.user.id
    puts conversation.recipient.id
    puts @current_user
    puts (message.user == conversation.recipient)
    puts (@current_user == message.user)
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    data = {}
    data["recipient_id"] = conversation.recipient_id
    data["sender_id"] = conversation.sender_id
    data["created_at"] = conversation.created_at
    data["updated_at"] = conversation.updated_at
    data["is_blocked"] = conversation.is_blocked
    data["message"] = message.body
    data["unread_message"] = (message.user == conversation.recipient)  && (@current_user == message.user) ? conversation.unread_message : 0
    if conversation&.sender == @current_user
      data["full_name"] = conversation&.recipient&.full_name
    else
      data["full_name"]= conversation&.sender&.full_name
    end
    if conversation&.sender == @current_user
      data["avatar"] = conversation&.recipient&.avatar&.url
    else
      data["avatar"] = conversation&.sender&.avatar&.url
    end
    return data
  end

end

# data= {}
# data["recipient_id"] = conversation.recipient_id
# data["sender_id"] = conversation.sender_id
# data["created_at"] = conversation.created_at
# data["updated_at"] = conversation.updated_at
# data["is_blocked"] = conversation.is_blocked
# data["message"] = conversation.messages.last
# if @conversation&.sender == @conversation.messages.last.user
#   data["unread_message"] = conversation.unread_message
# end
# if conversation&.sender == @current_user
#   data["full_name"] = conversation&.recipient&.full_name
# else
#   data["full_name"]= conversation&.sender&.full_name
# end
# if conversation&.sender == @current_user
#   data["avatar"] = conversation&.recipient&.avatar&.url
# else
#   data["avatar"] = conversation&.sender&.avatar&.url

# end
