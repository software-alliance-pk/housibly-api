class NotificationsController < ApplicationController
  before_action :set_notifications

  def index

  end

  def set_notifications
    @notification = Notification.where(recipient: @current_admin).unread
  end
end