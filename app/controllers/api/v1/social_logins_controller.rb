class Api::V1::SocialLoginsController < Api::V1::ApiController
  skip_before_action :authenticate_user, only: [:social_login]
  def social_login
    return render json: {message: 'Invalid type of resource'}, status: :unprocessable_entity unless params['provider'].present?
    return render json: {message: 'Please provide social login token'}, status: :unprocessable_entity unless params['token'].present?
    response = SocialLoginService.new(params['provider'], params['token']).social_login

    if response[0]&.class&.to_s == "User"
      @user = response[0]
      @token = response[1]

      handle_mobile_device_token if params['mobile_device_token'].present?
    else
      render json: { message: "Token has been Expired" }, status: :unprocessable_entity
    end
  end

  private

  def handle_mobile_device_token
    mobile_device = @user.mobile_devices.find_or_create_by(mobile_device_token: params['mobile_device_token'])

    if mobile_device.id
      @mobile_device_token = mobile_device.mobile_device_token
    else
      render_error_messages(mobile_device)
    end
  end
end
