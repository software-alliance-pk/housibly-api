class SupportsController < ApplicationController
  before_action :set_user_list, only: [:index,:get_specific_chat]
  before_action :get_support_ticket, only: [:ticket_in_progress,:ticket_closed,:ticket_pending]

  def index
    notification = AdminNotification.find_by(id:params[:id])
    notification.update(read_at:Time.now) if notification.present?
    @message = @end_users.first
  end

  def create
    respond_to do |format|
    conversation = current_admin.support_conversations.find_by(id: params[:id])
    if conversation.present?
       @message = conversation.admin_support_messages.new(sender_id: current_admin.id ,body: params[:text],image: params[:image],file: params[:file])
       if @message.save
        if conversation.sender.user_setting.push_notification == true
          UserNotification.create(actor_id: current_admin.id, recipient_id:conversation.sender_id, action: @message.body,title: "MESSAGE from Support",conversation_id: conversation.id, event_type: "support_message" )
        else
          puts "OOooOOffFFff Notification"
        end
          data = {}
          data["id"] = @message.id
          data["support_conversation_id"] = @message.support_conversation_id
          data["body"] = @message.body
          data["user_id"] = @message.sender_id
          data["sender_id"] = @message.support_conversation.sender.id
          data["recipient_id"] =  @message.support_conversation.recipient.id
          data["created_at"] = @message.created_at
          data["updated_at"] = @message.updated_at
          data["image"] = @message&.image&.url
          ActionCable.server.broadcast "support_conversations_#{@message.support_conversation_id}", { title: 'dsadasdas', body: data.as_json }
         @conversation =  conversation.admin_support_messages.last
       end
    end
    format.js {
    render  :template => "supports/create.js.erb",
            :layout => false
    }
    end
  end

  def get_specific_chat
    @message = SupportConversation.find_by(id: params["id"])
    @message.support_messages.update(read_status: true) if @message.support_messages.present?
    render 'index'
  end

  def update_ticket_status
    @support = Support.find_by(id: params[:id])
    unless @support.present?
      redirect_back(fallback_location: root_path) and return
    end
    if params[:status] == "pending"
      @support.update(status: "pending")
      flash[:success_alert] = "Support Ticket status has been updated to Pending"

    elsif params[:status] == "in_progress"
      @support.update(status: "in_progress")
      flash[:success_alert] = "Support Ticket status has been updated to In-Progress"

    else params[:status] == "closed"
      @support.update(status: "closed")
      flash[:success_alert] = "Support Ticket Status has been updated to Closed"
    end
    redirect_to get_specific_chat_support_path(id: params[:id])
  end

  def set_user_list
    @support_closers = SupportConversation.support_closer.order(created_at: :desc)
    @end_users = SupportConversation.end_user.order(created_at: :desc)
  end

  def get_support_ticket
    @support = Support.find_by(id: params["id"])
  end

end
