class Api::V1::MessagesController < Api::V1::ApiController

	def create
		debugger
		@conversation = Conversation.find_by(id: params[:conversation_id])
		@message = @current_user.messages.build(message_params)
		@message.conversation_id = @conversation.id
		if @message.save
			@message
		else
			render_error_messages(@message)
		end
	end

	private
	def message_params
		params.require(:message).permit(:body, images: [])
	end
end
