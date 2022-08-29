class Api::V1::MessagesController < Api::V1::ApiController

	def create
		debugger
		@conversation = Conversation.find_by(id: params[:conversation_id])
		@message = @current_user.messages.build(message_params)
		@message.conversation_id = @conversation.id
		if @message.save
	    data = {}
        data["id"] = @message.id
        data["conversation_id"] = @message.conversation_id
        data["body"] = @message.body
        # data['unread'] = @message.conversation.un_read_messages
        # data['online'] = @message.conversation.user_status
        data["user_id"] = @message.user_id
        data["sender_id"] = @message.conversation.sender.id
        data["recipient_id"] = @message.conversation.recipient_id
        data["created_at"] = @message.created_at
        data["updated_at"] = @message.updated_at
        data["image"] = @message&.images.first&.url
        data["user_profile"] = @message&.user&.avatar&.url
			debugger
        ActionCable.server.broadcast "conversations_#{@message.conversation_id}", { title: 'dsadasdas', body: data.as_json }
		else
			render_error_messages(@message)
		end
	end

	private
	def message_params
		params.require(:message).permit(:body, images: [])
	end
end
