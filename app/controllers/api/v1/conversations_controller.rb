class Api::V1::ConversationsController < Api::V1::ApiController
	def create
		if Conversation.where(recipient_id: params[:conversation][:recipient_id] ,sender_id: @current_user.id).present? ||
      Conversation.where(recipient_id: @current_user.id ,sender_id: params[:conversation][:recipient_id]).present?
      @conversation = Conversation.where(recipient_id: params[:conversation][:recipient_id] ,sender_id: @current_user.id) ||
      @conversation = Conversation.where(recipient_id: @current_user.id ,sender_id: params[:conversation][:recipient_id])
      @conversation
    else
	    @conversation = Conversation.new(conversation_params)
	    @conversation.sender_id = @current_user.id
      if @conversation.save
        @conversation
      else
        render_error_messages(@conversation)
      end
    end
  end
  def index
    @conversations = Conversation.where("recipient_id = (?) OR  sender_id = (?)", @current_user.id, @current_user.id)      
  end
    def read_messages
    @conversation = Conversation.where("recipient_id = (?) OR  sender_id = (?) AND id = (?)", @current_user.id, @current_user.id, params[:conversation_id])
    if @conversation.present?
      @conversation.update(unread_message: 0)
      render json: { message: "message has been read" }, status: :ok
    else
      render json: { error: "No such conversation exists" }, status: :unprocessable_entity
    end
  end

  def destroy
    @conversation = Conversation.find_by(id: params[:id])
    if @conversation.present?
      @conversation.destroy
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


  private

  def conversation_params
    params.require(:conversation).permit(:recipient_id)
  end
end
