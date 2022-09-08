class SupportsController < ApplicationController
  before_action :set_user_list, only: [:index,:get_specific_chat]
  before_action :get_support_ticket, only: [:ticket_in_progress,:ticket_closed,:ticket_pending]
  
  def index
    @message = @end_users.first
  end

  def create
    respond_to do |format|
    conversation = current_admin.support_conversations.find_by(id: params[:id])
    if conversation.present?
       @message = conversation.admin_support_messages.new(sender_id: current_admin.id ,body: params[:text],image: params[:image],file: params[:file])
       if @message.save
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
    render  :template => "support/create.js.erb",
            :layout => false
    }
    end
  end

  def get_specific_chat
    @message = SupportConversation.find_by(id: params["id"])
    render 'index'
  end

  def ticket_in_progress
    @support.in_progress!
  end

  def ticket_closed
    @support.closed!
  end

  def ticket_pending
    @support.pending!
  end

  def set_user_list
    @support_closers = SupportConversation.support_closer.order(created_at: :desc)
    @end_users = SupportConversation.end_user.order(created_at: :desc)
  end

  def get_support_ticket
    @support = Support.find_by(id: params["id"])
  end
end