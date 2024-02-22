class Api::V1::SocialLoginsController < Api::V1::ApiController
  skip_before_action :authenticate_user, only: [:social_login]

  def social_login
    return render json: { message: 'provider parameter is missing' }, status: :unprocessable_entity unless params['provider'].present?

    response = case params[:provider].downcase
      when 'google'
        if params['token'].present?
          SocialLoginService.new(params['mobile_device_token']).google_signup(params['token'])
        else
          { error_message: 'token parameter is missing' }
        end
      when 'apple'
        if params[:provider_user_id].present?
          SocialLoginService.new(params['mobile_device_token']).apple_signup(params[:provider_user_id], params[:email], params[:name])
        else
          { error_message: 'provider_user_id parameter is missing' }
        end
      else
        { error_message: 'Invalid value for provider' }
      end

    if response[:error_message]
      render json: { message: response[:error_message] }, status: :unprocessable_entity
    else
      @user = response[:user]
      @token = response[:token]

      mobile_device = @user.mobile_devices.find_or_create_by(mobile_device_token: params['mobile_device_token'])
      if mobile_device.id
        @mobile_device_token = mobile_device.mobile_device_token
      else
        render_error_messages(mobile_device)
      end
    end
  end
end
