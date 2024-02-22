class Api::V1::UserSettingsController < Api::V1::ApiController

  def show_current_user_setting
    @user_settings = @current_user.user_setting
  end

  def update_current_user_setting
    user_settings = current_user.user_setting

    if user_settings.update(user_setting_params)
      render json: {
        user_id: user_settings.user_id,
        push_notification: user_settings.push_notification,
        inapp_notification: user_settings.inapp_notification,
        email_notification: user_settings.email_notification,
        message: 'User settings updated successfully'
      }
    else
      render_error_messages(user_settings)
    end
  end

  private

  def user_setting_params
    params.require(:user_setting).permit(:push_notification, :inapp_notification, :email_notification)
  end

end
