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
    @list, user = notify_second_user(@conversation)
  end

  def index
    @conversations = Conversation.find_specific_conversation(@current_user.id)
    data = []
    @conversations.each do |conversation|
      data << compile_message(conversation)
    end
    #.where(read_status: false).where.not(user_id: current_user.id).count
    ActionCable.server.broadcast "user_chat_list_#{@current_user.id}", { data: data.as_json }
  end

  def read_messages
    _conversation = Conversation.find_by("recipient_id = (?) OR  sender_id = (?) AND id = (?)", @current_user.id, @current_user.id,  params[:conversation_id)
    if _conversation.present?
      if _conversation&.messages.last&.user != @current_user
        data = []
        _conversation.messages.where.not(id: @current_user.id).update_all(read_status: true)
        @conversations = Conversation.find_specific_conversation(_conversation.recipient.id)
        @conversations.each do |conversation|
          data << compile_message(conversation)
        end
        broadcast_to_user = _conversation&.sender == @current_user ? _conversation.recipient.id : _conversation.sender.id
        ActionCable.server.broadcast "user_chat_list_#{broadcast_to_user}", { data: data.as_json }
        render json: { message: "Read Messages Successfully" }, status: :ok
      else
        render json: { message: "You already ready your messages" }, status: :ok
      end
    else
      render json: { message: "No such conversation exists" }, status: :ok
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
    mtoken = @current_user.mobile_devices.find_by(mobile_device_token: params[:mtoken])
    if mtoken.present?
      mtoken.destroy
      render json: { message: "Log out successfully" }, status: :ok
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:recipient_id)
  end

  def check_conversation_exists
    @conversation = Conversation.get_chat_between_user(params[:conversation][:recipient_id], @current_user.id)
    unless @conversation.present?
      @conversation = Conversation.with_deleted.
        get_chat_between_user(params[:conversation][:recipient_id], @current_user.id)
      @conversation.recover if @conversation.present?
    end
  end
end
