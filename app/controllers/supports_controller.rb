class SupportsController < ApplicationController
  def index
    @support_closers = SupportConversation.support_closer.order(created_at: :desc)
    @end_users = SupportConversation.end_user.order(created_at: :desc)
    @message = @end_users.first
  end

  def get_conversation

  end

  def create
    debugger
    @conversation = current_admin.support_conversations.find_by(id: params[:id])
    if @conversation.present?
      @conversation.support_messages.create!(user_id: current_admin.id,body: params[:text])
    end
  end
end