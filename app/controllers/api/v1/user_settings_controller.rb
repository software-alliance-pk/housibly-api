# frozen_string_literal: true

class Api::V1::UserSettingsController < Api::V1::ApiController

  def show
    @user_setting = @current_user.user_setting
  end

  def update
    @user_setting = @current_user.user_setting

    if @user_setting.update(user_setting_params)
      render 'show'
    else
      render_error_messages(@user_setting)
    end
  end

  private

    def user_setting_params
      params.require(:user_setting).permit(:push_notification, :inapp_notification, :email_notification, :vibration, :payment_method)
    end

end
