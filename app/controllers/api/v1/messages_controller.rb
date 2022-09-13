class Api::V1::MessagesController < Api::V1::ApiController

	def create
		going_to_recover = false
		@conversation = Conversation.find_by(id: params[:conversation_id]) rescue nil
		going_to_recover = true unless @conversation.present?
		@conversation = Conversation.with_deleted.find_by(id: params[:conversation_id]) unless @conversation.present?
		@conversation.recover unless @conversation.present? && !going_to_recover
		if @conversation.is_blocked == false
			@message = @current_user.messages.build(message_params)
			@message.conversation_id = @conversation.id
			if @message.save
				data = compile_message(@message)
		      if @conversation.sender == @current_user
		         UserNotification.create(actor_id: @current_user.id,recipient_id:@conversation.recipient_id, action: @message.body,title: "#{@current_user.full_name} sent to a message.",conversation_id: @conversation.id )
		      else
		         UserNotification.create(actor_id: @current_user.id,recipient_id:@conversation.sender_id, action: @message.body,title: "#{@current_user.full_name} sent to a message.",conversation_id: @conversation.id )
		      end
        ActionCable.server.broadcast "conversations_#{@message.conversation_id}", data.as_json
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
  	conversations = Conversation.where("recipient_id = (?) OR  sender_id = (?)", @current_user.id, @current_user.id)
  	conversations.each do |conversation|
  		if UserNotification.where(recipient_id: @current_user.id, actor_id: conversation.sender).present?
  	   notification = UserNotification.where(recipient_id: @current_user.id, actor_id: conversation.sender_id).last
  	  elsif UserNotification.where(recipient_id: @current_user.id, actor_id: conversation.recipient_id).present?
  	   notification = UserNotification.where(recipient_id: @current_user.id, actor_id: conversation.recipient_id).last
  	  end

  	  # if UserNotification.where(recipient_id: conversation.recipient_id, actor_id: conversation.sender_id).present?
  	  #  notification = UserNotification.where(recipient_id: conversation.recipient_id, actor_id: conversation.sender_id).last
  	  # elsif UserNotification.where(recipient_id: conversation.sender_id, actor_id: conversation.recipient_id).present?
  	  #  notification = UserNotification.where(recipient_id: conversation.sender_id, actor_id: conversation.recipient_id).last
  	  # end
  	   @notifications << notification
  	end
	if @notifications
		@notifications
	else
	  render json: {message: []},status: :ok
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
