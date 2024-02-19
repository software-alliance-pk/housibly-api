class Api::V1::SessionsController < Api::V1::ApiController
  skip_before_action :authenticate_user, only: [:login]

  def login
    @user = User.find_by(email: user_params[:email])
    if @user&.authenticate(user_params[:password])
      if @user.present?
        @token = JsonWebTokenService.encode({ email: @user.email })
        mobile_device = @user.mobile_devices.find_or_create_by(mobile_device_token: user_params.dig(:mobile_devices_attributes, 0, :mobile_device_token))
        if mobile_device.id
          @mobile_device_token = mobile_device.mobile_device_token
        else
          render_error_messages(mobile_device)
        end
      else
        render json: { message: "Please verify email address" }, status: :unauthorized
      end
    else
      render json: { message: "Incorrect email or password" }, status: :unauthorized
    end
  end

  def logout
    if params[:mobile_device_token].present?
      mtoken = @current_user.mobile_devices.find_by(mobile_device_token: params[:mobile_device_token])
      if mtoken.present?
        mtoken.destroy
        render json: { message: "Log out successfully" }, status: :ok
      else
        render json: { message: "Provide mobile token is not correct" }, status: :ok
      end
    else
      render json: { message: "Mobile token parameter is missing" }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, mobile_devices_attributes: [:mobile_device_token])
  end
end
