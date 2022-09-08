class SupportsController < ApplicationController
  before_action :set_user_list, only: [:index,:get_specific_chat]
  before_action :get_support_ticket, only: [:ticket_in_progress,:ticket_closed,:ticket_pending]
  def index
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