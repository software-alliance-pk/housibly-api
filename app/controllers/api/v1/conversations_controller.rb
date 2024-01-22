class Api::V1::ConversationsController < Api::V1::ApiController
  include ChatListBoardCast

  def create
    if conversation_params[:recipient_id].present?
      check_conversation_exists
      if @conversation.present?
        render json: @conversation
      else
        unless conversation_params[:recipient_id].to_i == @current_user.id
          conversation_parameter = conversation_params.merge(sender_id: current_user.id)
          @conversation = Conversation.new(conversation_parameter)
  
          if @conversation.save
            render json: @conversation
          else
            render_error_messages(@conversation)
          end
        else
          render json: { message: "You can't create your own conversation" }, status: :bad_request
        end
      end
    else
      render json: { message: "Recipient id parameter is missing" }, status: :bad_request
    end
  end
  
  def index
    @conversations = Conversation.find_user_conversations(@current_user.id)
    data = []
    @conversations.each do |conversation|
      data << compile_message(conversation)
    end
    ActionCable.server.broadcast "user_chat_list_#{@current_user.id}", { data: data.as_json }
  end
  
  def read_messages
    if params[:conversation_id].present?
      _conversation = Conversation.find_by("recipient_id = (?) OR  sender_id = (?) AND id = (?)", @current_user.id, @current_user.id, params[:conversation_id])
      if _conversation.present?
        if _conversation&.messages.last&.user != @current_user
          data = []
          _conversation.messages.where.not(id: @current_user.id).update_all(read_status: true)
          @conversations = Conversation.find_user_conversations(_conversation.recipient.id)
          @conversations.each do |conversation|
            data << compile_message(conversation)
          end
          broadcast_to_user = _conversation&.sender == @current_user ? _conversation.recipient.id : _conversation.sender.id
          ActionCable.server.broadcast "user_chat_list_#{broadcast_to_user}", { data: data.as_json }
          render json: { message: "Read Messages Successfully" }, status: :ok
        else
          render json: { message: "You already read your messages" }, status: :ok
        end
      else
        render json: { message: "No such conversation exists" }, status: :ok
      end
    else
      render json: { message: "Conversation id is missing" }, status: :ok
    end
  end

  def destroy
    if params[:id].present?
      @conversation = current_user.conversations.find_by(id: params[:id])
      if @conversation.present?
        @conversation.destroy
        render json: { message: "Conversation is successfully deleted" }, status: :ok
      else
        render json: { error: "Conversation doesn't exist or doesn't belong to the current user" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Conversation ID not provided" }, status: :unprocessable_entity
    end
  end

  def notification_token
    if params[:token].present?
      token = @current_user.mobile_devices.find_or_create_by(mobile_device_token: params[:token])
      @current_user.update(last_seen: Time.now)
      if token.save
        render json: { message: 'Success', status: 'ok', token: token }
      end
    else
      render json: { message: "Mobile token parameter is missing" }, status: :ok
    end
  end

  def logout
    if params[:mtoken].present?
      mtoken = @current_user.mobile_devices.find_by(mobile_device_token: params[:mtoken])
      if mtoken.present?
        mtoken.destroy
        render json: { message: "Log out successfully" }, status: :ok
      else
        render json: { message: "Provide mobile token is not correct" }, status: :ok
      end
    else
      render json: { message: "Mobile token parameter is missing" }, status: :ok
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
