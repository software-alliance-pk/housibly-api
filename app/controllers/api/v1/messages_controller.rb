class Api::V1::MessagesController < Api::V1::ApiController

	def create
		conversation = Conversation.find_by(id: params[:conversation_id])
		debugger
		@message = @current_user.messages.build(message_params)
		@message.conversation_id = conversation.id //
		if @message.save
			compile_message(@message)
      if @conversation.sender == @current_user
      	debugger
         Notification.create(actor_id: @current_user.id,recipient_id:conversation.recipient_id, notifiable: @current_user, action: "Read new message" )
      else
      	debugger
         Notification.create(actor_id: @current_user.id,recipient_id:conversation.sender_id, notifiable: @current_user, action: "Read new message" )
      end
      ActionCable.server.broadcast "conversations_#{@message.conversation_id}", { title: 'dsadasdas', body: data.as_json }
	else
			render_error_messages(@message)
		end
	end

	def index
	  @conversation = Conversation.find_by(id: params[:conversation_id])
    if @conversation.present?
      @messages = @conversation.messages.all.order(created_at: :desc)
    else
      not_found
    end
  end

	private
	def message_params
		params.require(:message).permit(:body, images: [])
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
    data["image"] = message&.images.first&.url
    data["user_profile"] = message&.user&.avatar&.url
	end
end
