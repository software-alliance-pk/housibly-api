class SupportsController < ApplicationController
  def index
    @support_closers = SupportConversation.support_closer.order(created_at: :desc)
    @end_users =  SupportConversation.end_user.order(created_at: :desc)
    @message = @end_users.first.messages
  end

  def get_conversation

  end

  def send_message

  end
end