class NotificationsController < ApplicationController
  before_action :set_notifications

  def index

  end

  def set_notifications
    @notifications = Notification.where(recipient: @current_admin).unread.order(created_at: :desc)
  end
end