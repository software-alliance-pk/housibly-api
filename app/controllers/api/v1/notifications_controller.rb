class Api::V1::NotificationsController < Api::V1::ApiController

  def mark_as_read
		notifications = Notification.where(recipient_id: @current_user.id, seen: false) || Notification.where(actor_id: @current_user.id, seen: false)
		return render json: { message: "No unseen notifications found" } if notifications.empty?

		if notifications.update_all(seen: true)
			render json: { message: "Notifications marked as seen successfully" }
		else
			render_error_messages(notifications)
		end
	end

  def get_user_notifications
		@notifications = []
		unless @current_user.user_setting.inapp_notification == false
			@notifications = UserNotification.where(recipient_id: @current_user.id).order(created_at: :desc)
		end
	end

  def delete_notification
		if params[:id].present?
			@notification = Notification.find_by(id: params[:id])
		  if @notification.present?
			  @notification.destroy
				render json: {message: "Notification deleted successfully"},status: :ok
			else
				render json: {message: "Notification is not present"},status: :ok
			end
		else
			render json: {message: "Notification id parameter is missing"},status: :ok
		end
  end
end
