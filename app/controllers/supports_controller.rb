class SupportsController < ApplicationController
  def index
    @support_closers = SupportConversation.support_closer.order(created_at: :desc)
    @end_users = SupportConversation.end_user.order(created_at: :desc)
    @message = @end_users.first
  end
  def create
    conversation = current_admin.support_conversations.find_by(id: params[:id])
    if conversation.present?
       conversation.admin_support_messages.create(sender_id: current_admin.id ,body: params[:text])
       @conversation =  conversation.admin_support_messages.last
    end
  end

  def get_specific_chat
    @support_closers = SupportConversation.support_closer.order(created_at: :desc)
    @end_users = SupportConversation.end_user.order(created_at: :desc)
    @message = SupportConversation.find_by(id: params["id"])
    render 'index'
  end
end