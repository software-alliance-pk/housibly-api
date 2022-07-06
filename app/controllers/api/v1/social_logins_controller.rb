class Api::V1::SocialLoginsController < Api::V1::ApiController
  skip_before_action :authenticate_user, only: [:social_login]
  def social_login
    return render json: {error: 'Invalid type of resource'}, status: :unprocessable_entity unless params['provider'].present?
    return render json: {error: 'Please provide social login token'}, status: :unprocessable_entity unless params['token'].present?
    response = SocialLoginService.new(params['provider'], params['token']).social_login
    puts response
    if  response[0]&.class&.to_s == "User"
      @user = response[0]
      @token = response[1]
    else
      render json: { error: "Token has been Expired" }, status: :unprocessable_entity
    end
  end
end
