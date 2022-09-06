class Api::V1::SupportConversationsController < Api::V1::ApiController
  def create
    @conversation = SupportConversation.find_by(support_id: params[:support_id])
    unless @conversation.present?
      support = Support.find_by(id: params[:support_id])
      @conversation = support.build_support_conversation
      @conversation.sender_id = current_user.id
      @conversation.recipient_id = params[:recipient_id]
      if current_user.want_support_closer?
        @conversation.update(conv_type: "support_closer")
      else
        @conversation.update(conv_type: "end_user")
      end
      if @conversation.save
       @conversation
      else
        render_error_messages(@conversation)
      end
    else
      render json: {message: "You can not create conversation again."}
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
		@conversation = SupportConversation.find_by(id: params[:support_conversation_id])
		@message = @current_user.support_messages.build(message_params)
		@message.support_conversation_id = @conversation.id
		if @message.save
		    data = {}
	        data["id"] = @message.id
	        data["support_conversation_id"] = @message.support_conversation_id
	        data["body"] = @message.body
	        data["user_id"] = @message.user_id
	        data["sender_id"] = @message.support_conversation.sender.id
	        data["recipient_id"] = @message.support_conversation.recipient_id
	        data["created_at"] = @message.created_at
	        data["updated_at"] = @message.updated_at
	        data["image"] = @message&.image&.url
	        data["user_profile"] = @message&.user&.avatar&.url
	        ActionCable.server.broadcast "conversations_#{@message.support_conversation_id}", { title: 'dsadasdas', body: data.as_json }
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

