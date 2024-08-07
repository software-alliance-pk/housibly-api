class Api::V1::SupportConversationsController < Api::V1::ApiController
  def create
    @conversation = SupportConversation.find_by(support_id: params[:support_id])
    unless @conversation.present?
      support = current_user.supports.find_by(id: params[:support_id])
      conv_type = current_user.support_closer? ? "support_closer" : "end_user"
      @conversation = support.build_support_conversation(recipient_id: Admin.admin.first.id, sender_id: current_user.id, conv_type: conv_type)
      if @conversation.save
       @conversation
      else
        render_error_messages(@conversation)
      end
    else
      @conversation
    end
  end

  def index
    @conversations = SupportConversation.where("recipient_id = (?) OR  sender_id = (?)", @current_user.id, @current_user.id)
  end

  def destroy
    @conversation = SupportConversation.find_by(id: params[:id])
    if @conversation.present?
      @conversation.destroy
      render json: { message: "Conversation is successfully deleted" }, status: :ok
    else
      render json: { error: "No Found" }, status: :unprocessable_entity
    end
  end

def create_message
    render json: { error: "Params are missing." }, status: :unprocessable_entity and return if !params[:message].present?
    render json: { error: "Message body and Image both are not present." }, status: :unprocessable_entity and return if !params[:message][:body].present? && !params[:message][:image].present?
    going_to_recover = false
		@conversation = SupportConversation.find_by(id: params[:support_conversation_id]) rescue nil
    going_to_recover = true unless @conversation.present?
    @conversation = SupportConversation.with_deleted.find_by(id: params[:support_conversation_id]) unless @conversation.present?
		@message = @current_user.user_support_messages.build(message_params)
		@message.support_conversation_id = @conversation.id
		if @message.save
      data = {}
      data["id"] = @message.id
      data["support_conversation_id"] = @message.support_conversation_id
      data["body"] = @message.body.present? ? @message.body : ""
      data["user_id"] = @message.sender_id
      data["sender_id"] = @message.support_conversation.sender.id
      data["recipient_id"] = Admin.admin.first
      data["created_at"] = @message.created_at
      data["updated_at"] = @message.updated_at
      data["image"] = @message&.image&.url
      data["user_profile"] = @message&.user&.avatar&.url.present? ? @message&.user&.avatar&.url : ''
		else
			render_error_messages(@message)
		end
	end

	def get_messages
	  @conversation = SupportConversation.find_by(id: params[:support_conversation_id])
    if @conversation.present?
      @messages = @conversation.support_messages.all.order(created_at: :desc)
    else
      not_found
    end
  end

  private

  def message_params
		params.require(:message).permit(:body, :image)
	end

end
