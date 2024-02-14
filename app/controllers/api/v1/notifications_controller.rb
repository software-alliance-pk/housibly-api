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
end
