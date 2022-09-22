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
					if @conversation&.sender == @current_user
						@conversation_list.each do |conversation|
							data << read_message_compile_message(conversation)
						end
						ActionCable.server.broadcast "user_chat_list_#{@conversation.recipient.id}",  { data:  data.as_json}
					else
						@conversation_list.each do |conversation|
							data << read_message_compile_message(conversation)
						end
						ActionCable.server.broadcast "user_chat_list_#{@conversation.sender.id}",  { data:  data.as_json}
					end
					send_message = compile_conversation_boardcasting_data(@conversation)
					ActionCable.server.broadcast "conversations_#{@message.conversation_id}", { messages: send_message}
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
      not_found
    end
  end
  def delete_notification
  	notification = Notification.find(id: params[:notification_id])
  	if @notification.destroy
  		render json: {message: "not found"},status: :ok
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

	def compile_message(message)
		_conversation = message.conversation
		data = {}
	  data["id"] = message.id
    data["conversation_id"] = _conversation.id
    data["body"] = message.body
    data["user_id"] = message.user_id
    data["sender_id"] = _conversation.sender.id
    data["recipient_id"] = _conversation.recipient_id
    data["created_at"] = message.created_at
    data["updated_at"] = message.updated_at
    data["image"] = message&.image&.url
    data["user_profile"] = message.user&.avatar&.url
    data["message"] =  message.body
    data["is_blocked"] = _conversation.is_blocked
    data["unread_message"] = (_conversation.user == _conversation.sender)  && (@current_user == _conversation.user)? _conversation.unread_message : 0
	  data["full_name"] = message.user == @current_user ? _conversation&.recipient&.full_name : _conversation&.sender&.full_name
    data["avatar"] =  message.user == @current_user ?  _conversation&.recipient&.avatar&.url :  _conversation&.sender&.avatar&.url
    return data
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


	def un_read_message_attribute(conversation,message)
		if conversation.sender == @current_user

		else

		end
	end
end
