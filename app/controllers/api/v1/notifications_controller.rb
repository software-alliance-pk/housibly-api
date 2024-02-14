class Api::V1::NotificationsController < Api::V1::ApiController

  def mark_as_read
    notification = Notification.find_by_id(params[:id])
    return render json: {message: "Could not find notification"}, status: :not_found unless notification

    if notification.update(seen: true, read_at: Time.now)
      render json: { message: "Notification marked as read successfully" }
    else
      render_error_messages(notification)
    end
  end

  def get_user_notifications
		@notifications = []
		unless @current_user.user_setting.inapp_notification == false
			@notifications = UserNotification.where(recipient_id: @current_user.id).order(created_at: :desc)
		end
	end

  def delete_notification
		if params[:notification_id].present?
			@notification = Notification.find(id: params[:notification_id])
			if @notification.present?
				@notification
				render json: {message: "Notification deleted successfully"},status: :ok
			else
				render json: {message: "Notification is not present"},status: :ok
			end
		else
			render json: {message: "Notification id parameter is missing"},status: :ok
		end
  end
end
