class Api::V1::MessagesController < Api::V1::ApiController

	def create
		conversation = Conversation.find_by(id: params[:conversation_id])
		@message = @current_user.messages.build(message_params)
		@message.conversation_id = conversation.id 
		if @message.save
			data = compile_message(@message)
      if conversation.sender == @current_user
         UserNotification.create(actor_id: @current_user.id,recipient_id:conversation.recipient_id, action: "Read new message" )
      else
         UserNotification.create(actor_id: @current_user.id,recipient_id:conversation.sender_id, action: "Read new message" )
      end
      ActionCable.server.broadcast "conversations_#{@message.conversation_id}", { title: 'dsadasdas', body: data.as_json }
      render json: {message: "success"},status: :ok
	else
			render_error_messages(@message)
		end
	end

	def get_messages
	  @conversation = Conversation.find_by(id: params[:conversation_id])
    if @conversation.present?
      @messages = @conversation.messages.all.order(created_at: :desc)
    else
      not_found
    end
  end

	private
	def message_params
		params.require(:message).permit(:body, :image)
	end

	def compile_message(message)
		data = {}
	  data["id"] = message.id
    data["conversation_id"] = message.conversation_id
    data["body"] = message.body
    data["user_id"] = message.user_id
    data["sender_id"] = message.conversation.sender.id
    data["recipient_id"] = message.conversation.recipient_id
    data["created_at"] = message.created_at
    data["updated_at"] = message.updated_at
    data["image"] = message&.image&.url
    data["user_profile"] = message&.user&.avatar&.url
    return data
	end
end
