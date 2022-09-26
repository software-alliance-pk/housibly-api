class Api::V1::MessagesController < Api::V1::ApiController
	include ChatListBoardCast
	before_action :find_conversation, only: [:create]
	def create
		unless @conversation.is_blocked?
			@message = @current_user.messages.build(message_params.merge(conversation_id: @conversation.id))
			if @message.save
				send_notification_to_user(@conversation,@message)
				@conversation_list, user = notify_second_user(@conversation)
				data = []
				@conversation_list.each do |conversation|
					data << compile_message(conversation)
						if conversation&.messages.present?
							if conversation&.messages&.last&.user == @message.user
								data["avatar"] = (@message.user == @current_user ? conversation.recipient&.avatar&.url : conversation&.sender&.avatar&.url)
								data["full_name"] = (@message.user == @current_user ? conversation.recipient&.full_name : conversation&.sender&.full_name)
							end
						end
				end
				puts data
				broadcast_to_user = @message.user == @conversation.sender ? @conversation.recipient.id : @conversation.sender.id
				ActionCable.server.broadcast "conversations_#{@message.conversation_id}", { messages: compile_message(@conversation)}
				ActionCable.server.broadcast "user_chat_list_#{broadcast_to_user}",  { data:  data.as_json}
			else
				render_error_messages(@message)
			end
		end
	end

	def get_messages
	  @conversation = Conversation.find_by(id: params[:conversation_id])
    if @conversation.present?
      @messages = @conversation.messages.all.order(created_at: :desc)
    else
			render json: {message: "Conversation not found"},status: :ok
    end
  end
  def delete_notification
  	notification = Notification.find(id: params[:notification_id])
  	if @notification.destroy
  		render json: {message: "Notificatoin deleted successfully"},status: :ok
		end
  end 
  def get_notification
  	@notifications = []
  	unless @current_user.user_setting.inapp_notification == false
	  	conversations = Conversation.where("recipient_id = (?) OR  sender_id = (?)", @current_user.id, @current_user.id)
	  	conversations.each do |conversation|
				_notification = UserNotification.check_notifiction_send(@current_user.id,conversation.sender_id)
				_notification = UserNotification.check_notifiction_send(@current_user.id,conversation.recipient_id) unless _notification.present?
				_notification = 	_notification.last
	  	  # if UserNotification.where(recipient_id: conversation.recipient_id, actor_id: conversation.sender_id).present?
	  	  #  notification = UserNotification.where(recipient_id: conversation.recipient_id, actor_id: conversation.sender_id).last
	  	  # elsif UserNotification.where(recipient_id: conversation.sender_id, actor_id: conversation.recipient_id).present?
	  	  #  notification = UserNotification.where(recipient_id: conversation.sender_id, actor_id: conversation.recipient_id).last
	  	  # end
	  	  unless _notification == nil
	  	   @notifications <<	_notification
	  	 end
	  	end
		if @notifications
			@notifications
		else
		  render json: {message: []},status: :ok
		end
	end
end

	private
	def message_params
		params.require(:message).permit(:body, :image)
	end

	def find_conversation
		@conversation = Conversation.find_by(id: params[:conversation_id])
		unless @conversation.present?
			@conversation = Conversation.with_deleted.find_by(id: params[:conversation_id])
			@conversation.recover if @conversation.present?
		end
		render json: {message: "Conversation does n't exists"}, status: 200 unless @conversation
	end

	def send_notification_to_user(conversation,message)
		unless @current_user.user_setting.push_notification == false
			if conversation.sender == @current_user
				UserNotification.create(actor_id: @current_user.id,recipient_id:conversation.recipient_id, action: message.body,title: "#{@current_user.full_name} sent to a message.",conversation_id: conversation.id )
			else
				UserNotification.create(actor_id: @current_user.id,recipient_id:conversation.sender_id, action: message.body,title: "#{@current_user.full_name} sent to a message.",conversation_id: conversation.id )
			end
		end
	end
end
