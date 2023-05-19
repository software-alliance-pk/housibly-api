class Api::V1::MessagesController < Api::V1::ApiController
	include ChatListBoardCast
	before_action :find_conversation, only: [:create]
	def create
		unless @conversation.is_blocked?
			@message = @current_user.messages.build(message_params.merge(conversation_id: @conversation.id))
			if @message.save
				# send_notification_to_user(@conversation,@message)
				@conversation_list, user = notify_second_user(@conversation)
				data = []
				@conversation_list.each do |conversation|
					custom_data = compile_message(conversation)
						if conversation&.messages.present?
								custom_data["avatar"] = conversation&.sender.id == @message.user.id ? conversation&.sender&.avatar&.url : conversation.recipient&.avatar&.url
								custom_data["full_name"] = conversation&.sender.id == @message.user.id ? conversation&.sender&.full_name :  conversation.recipient&.full_name
						end
					data << custom_data
				end
				puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
				puts "message is send by #{@message.user.full_name}"
				puts " Message #{data}"
				puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
				broadcast_to_user = @message.user == @conversation.sender ? @conversation.recipient.id : @conversation.sender.id
				ActionCable.server.broadcast "conversations_#{@message.conversation_id}", { messages: compile_message(@conversation)}
				puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
				puts "Message board casted to user_chat_list_#{broadcast_to_user}"
				puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
				ActionCable.server.broadcast "user_chat_list_#{broadcast_to_user}",  { data:  data.as_json}
			else
				render_error_messages(@message)
			end
		end
	end

	def get_messages
		if params[:conversation_id].present?
			@conversation = Conversation.find_by(id: params[:conversation_id])
			if @conversation.present?
				@messages = @conversation.messages.all.order(created_at: :desc)
			else
				render json: {message: "Conversation not found"},status: :ok
			end
		else
			render json: {message: "Conversation id parameter is missing"},status: :ok
		end
  end
  def delete_notification
		if params[:notification_id].present?
			@notification = Notification.find(id: params[:notification_id])
			if @notification.present?
				@notification
				render json: {message: "Notificatoin deleted successfully"},status: :ok
			else
				render json: {message: "Notification is not present"},status: :ok
			end
		else
			render json: {message: "Notification id parameter is missing"},status: :ok
		end
  end 
  def get_notification
  	@notifications = []
  	unless @current_user.user_setting.inapp_notification == false
  		puts "<<<<<<<<<<<<<<<InAppNotification<<<<<<<<<<<<<<<<<"
	  	conversations = Conversation.where("recipient_id = (?) OR  sender_id = (?)", @current_user.id, @current_user.id)
	  	conversations.each do |conversation|
				_notification = UserNotification.check_notifiction_send(@current_user.id,conversation.sender_id)
				_notification = UserNotification.check_notifiction_send(@current_user.id,conversation.recipient_id) unless _notification.present?
				_notification = 	_notification.last
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
		if params[:conversation_id].present?
			@conversation = Conversation.find_by(id: params[:conversation_id])
			unless @conversation.present?
				@conversation = Conversation.with_deleted.find_by(id: params[:conversation_id])
				@conversation.recover if @conversation.present?
			end
			render json: {message: "Conversation does n't exists"}, status: 200 unless @conversation
		else
			render json: {message: "Conversation id parameter is missing"}, status: 200
		end
	end

	def send_notification_to_user(conversation,message)
		puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
		puts conversation.sender.user_setting.push_notification
		puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
		if conversation.sender == @current_user
			if conversation.recipient.user_setting.push_notification == true
				UserNotification.create(actor_id: @current_user.id,recipient_id:conversation.recipient_id, action: message.body,title: "#{@current_user.full_name} sent to a message.",conversation_id: conversation.id )
			else
				puts "OFFFFFFFF"
			end
		else
			if conversation.sender.user_setting.push_notification == true
				UserNotification.create(actor_id: @current_user.id,recipient_id:conversation.sender_id, action: message.body,title: "#{@current_user.full_name} sent to a message.",conversation_id: conversation.id )
			else
				puts "<<<<<<<<<<OFF<<<<<<<<<<<"
			end
		end
	end
end
